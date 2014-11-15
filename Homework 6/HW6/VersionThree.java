import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.util.Scanner;

public class VersionThree implements VersionObject  {

	private Rectangle usaRect;
	private int totalPop=0;
	private CensusData cd;
	private float maxLat, minLat, maxLon, minLon, gridHeight, gridWidth;
	private int[][] grid; 
		
	//construct VersionObject with some CensusData
	public VersionThree(CensusData input) {
		cd = input;
	}
	
	// read in the data from the given file and preprocess it,
	// depending on which version of the algorithm is specified
    public void preprocess(int x, int y) {
	
		//Create the xy grid
		grid = new int[x][y];
	
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
		
		//Find populations for each individual grid element
		for(int i=0; i<cd.data_size; i++)
		{
			CensusGroup cg = cd.data[i];
			
			//Determine grid position of each census group
			float lon = cg.longitude-minLon;
			float lat = cg.latitude-minLat;
			int xPos=(int)(Math.abs(lon)/gridWidth);
			int yPos=(int)(Math.abs(lat)/gridHeight);
			
			//Check to make sure grids are in bounds
			//If xPos or yPos is already at its max value, subtract 1 to fit it into the grid array
			if(xPos==x)
				xPos--;
			if(yPos==y)
				yPos--;
			
			//Check if (xPos,yPos) is within selected bounds
			if(xPos>=0 && xPos<x && yPos>=0 && yPos<y)
				grid[xPos][yPos]+=cg.population;
		}
		
		//Update the grid elements to be cumulative
		for(int j=y-1; j>=0; j--) //top to bottom
			for(int i=0; i<x; i++) //left to right
			{	
				int left = (i!=0) ? grid[i-1][j] : 0;
				int top =  (j!=y-1) ? grid[i][j+1] : 0;
				int leftTop = (i!=0 && j!=y-1) ? grid[i-1][j+1] : 0;
				
				grid[i][j] = grid[i][j] + left + top - leftTop;
			}
			
		/*
		for(int i=11; i>=0; i--)
		{
			for (int j=0; j<=22; j++)
				System.out.print(grid[j][i] + " ");
				System.out.println("");
		}
		*/
	}

	// answer a query rectangle by providing the population in that region
	// as well as the percentage this represents of the total U.S. population
    public Pair<Integer, Float> singleInteraction(int w, int s, int e, int n) {
		
		//Decrement query grids to match array indices
		w--;
		s--;
		e--;
		n--;
		
		//Array dimensions
		int xSize = grid.length;
		int ySize = grid[0].length;
		
		//Calculate population
		int aboveTopRight = (n+1<=ySize-1) ? grid[e][n+1] : 0;
		int leftBottomLeft = (w-1>=0) ? grid[w-1][s] : 0;
		int aboveLeftUpperLeft = (w-1>=0 && n+1<=ySize-1) ? grid[w-1][n+1] : 0;
		int pop=grid[e][s] - aboveTopRight - leftBottomLeft + aboveLeftUpperLeft;
		
		return new Pair<Integer, Float>(new Integer(pop), new Float((float)(pop)/(float)(totalPop)*100));

	}
}
