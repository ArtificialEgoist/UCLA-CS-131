import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.util.Scanner;

public class VersionOne implements VersionObject  {

	private Rectangle usaRect;
	private int totalPop=0;
	private CensusData cd;
	private float maxLat, minLat, maxLon, minLon, gridHeight, gridWidth;
	private int maxX, maxY;
		
	//construct VersionObject with some CensusData
	public VersionOne(CensusData input) {
		cd = input;
	}
	
	// read in the data from the given file and preprocess it,
	// depending on which version of the algorithm is specified
    public void preprocess(int x, int y) {
	
		maxX=x;
		maxY=y;
	
		maxLat = cd.data[0].latitude;
		minLat = cd.data[0].latitude;
		maxLon = cd.data[0].longitude;
		minLon = cd.data[0].longitude;
		
		totalPop=0;
		
		//Determine total population and min/max longitude/latitude
		for(int i=0; i<cd.data_size; i++)
		{
			CensusGroup cg = cd.data[i];
		
			totalPop+=cg.population;
		
			float currLat = cg.latitude;
			float currLon = cg.longitude;
			
			if(currLat>maxLat)
				maxLat=currLat;
			if(currLat<minLat)
				minLat=currLat;
				
			if(currLon>maxLon)
				maxLon=currLon;
			if(currLon<minLon)
				minLon=currLon;
		}
		
		//Create the entire rectangle using min/max points
		usaRect = new Rectangle(minLon, maxLon, maxLat, minLat);
		
		gridHeight = Math.abs((minLat-maxLat)/y);
		gridWidth = Math.abs((minLon-maxLon)/x);
		
		/*
		System.out.println("height: "+gridHeight);
		System.out.println("width: "+gridWidth);
		System.out.println("minLon: "+minLon);
		System.out.println("maxLon: "+maxLon);
		System.out.println("minLat: "+minLat);
		System.out.println("maxLat: "+maxLat);
		*/
	}

	// answer a query rectangle by providing the population in that region
	// as well as the percentage this represents of the total U.S. population
    public Pair<Integer, Float> singleInteraction(int w, int s, int e, int n) {
		Rectangle qRect = new Rectangle(w, e, n, s);
		int pop=0;
		
		for(int i=0; i<cd.data_size; i++)
		{
			CensusGroup cg = cd.data[i];
			
			//Determine grid position of each census group
			float lon = cg.longitude-minLon;
			float lat = cg.latitude-minLat;
			int xPos=(int)(Math.abs(lon)/gridWidth);
			int yPos=(int)(Math.abs(lat)/gridHeight);
			
			//Check to make sure grids are in bounds of the largest rectangle
			if(xPos!=maxX)
				xPos++;
			if(yPos!=maxY)
				yPos++;
		
			//Check if (xPos,yPos) is within selected bounds
			if(xPos>=w && xPos<=e && yPos>=s && yPos<=n)
				pop+=cg.population;
		}
		
		return new Pair<Integer, Float>(new Integer(pop), new Float((float)(pop)/(float)(totalPop)*100));

	}


}
