import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.util.Scanner;

class Corner {
	public Rectangle rect;
	public int population;
	
	public Corner(Rectangle r, int p) {
		this.rect=r;
		this.population=p;
	}
}

class Grid {
	public Corner corn;
	public float minLon, minLat, gridWidth, gridHeight;
	public int maxX, maxY;
	
	public Grid(Corner c, float lon, float lat, float width, float height, int x, int y) {
		this.corn=c;
		this.minLon=lon;
		this.minLat=lat;
		this.gridWidth=width;
		this.gridHeight=height;
		this.maxX=x;
		this.maxY=y;
	}
}

class CornerTask extends RecursiveTask<Corner> {
	
	private final CensusGroup[] arr;
	private final int start, end;
	private static final int SEQUENTIAL_THRESHOLD = 100;
	
	public CornerTask(CensusGroup[] arr, int start, int end) {
		this.arr=arr;
		this.start=start;
		this.end=end;
	}
	
	public Corner compute() {
		int length = end-start; //find length of array
		if (length<SEQUENTIAL_THRESHOLD) //solve sequentially
		{
			float maxLat = arr[start].latitude;
			float minLat = arr[start].latitude;
			float maxLon = arr[start].longitude;
			float minLon = arr[start].longitude;
		
			int totalPop=0;
			
			for(int i = start; i < end; i++)
			{
				CensusGroup cg = arr[i];
			
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
			Rectangle cornerRect = new Rectangle(minLon, maxLon, maxLat, minLat);
			Corner corners = new Corner(cornerRect, totalPop);
			return corners;
		}
		
		int mid = (start+end)/2;
		
		CornerTask left = new CornerTask(arr, start, mid);
		CornerTask right = new CornerTask(arr, mid, end);
		left.fork();
		Corner second = right.compute();
		Corner first = left.join();
		
		Rectangle secondRect = second.rect;
		Rectangle firstRect = first.rect;
		
		float l=Math.min(secondRect.left, firstRect.left);
		float r=Math.max(secondRect.right, firstRect.right);
		float t=Math.max(secondRect.top, firstRect.top);
		float b=Math.min(secondRect.bottom, firstRect.bottom);
		int newPop=first.population+second.population;
		
		Rectangle cornerRect = new Rectangle(l, r, t, b);
		Corner corners = new Corner(cornerRect, newPop);
		return corners;
	}
}

class QueryTask extends RecursiveTask<Grid> {
	
	private final CensusGroup[] arr;
	private final int start, end;
	private static final int SEQUENTIAL_THRESHOLD = 100;
	private Grid g;
	
	public QueryTask(CensusGroup[] arr, int start, int end, Grid g) {
		this.arr=arr;
		this.start=start;
		this.end=end;
		this.g=g;
	}
	
	public Grid compute() {
		int length = end-start; //find length of array
		if (length<SEQUENTIAL_THRESHOLD) //solve sequentially
		{
			int pop=0;
			for(int i=start; i<end; i++)
			{
				CensusGroup cg = arr[i];
				
				//Determine grid position of each census group
				float lon = cg.longitude-g.minLon;
				float lat = cg.latitude-g.minLat;
				int xPos=(int)(Math.abs(lon)/g.gridWidth);
				int yPos=(int)(Math.abs(lat)/g.gridHeight);
			
				float w = g.corn.rect.left;
				float e = g.corn.rect.right;
				float s = g.corn.rect.bottom;
				float n = g.corn.rect.top;
				
				//Check to make sure grids are in bounds
				if(xPos!=g.maxX)
					xPos++;
				if(yPos!=g.maxY)
					yPos++;
			
				//Check if (xPos,yPos) is within selected bounds
				if(xPos>=w && xPos<=e && yPos>=s && yPos<=n)
					pop+=cg.population;
			}
			return new Grid(new Corner(g.corn.rect, pop), g.minLon, g.minLat, g.gridWidth, g.gridHeight, g.maxX, g.maxY);
		}
		
		int mid = (start+end)/2;
		
		QueryTask left = new QueryTask(arr, start, mid, g);
		QueryTask right = new QueryTask(arr, mid, end, g);
		left.fork();
		Grid second = right.compute();
		Grid first = left.join();
		
		return new Grid(new Corner(second.corn.rect, second.corn.population+first.corn.population), g.minLon, g.minLat, g.gridWidth, g.gridHeight, g.maxX, g.maxY);
	}
}

public class VersionTwo implements VersionObject  {

	private Rectangle usaRect;
	private int totalPop=0;
	private CensusData cd;
	private float maxLat, minLat, maxLon, minLon, gridHeight, gridWidth;
	private int maxX, maxY;
		
	//construct VersionObject with some CensusData
	public VersionTwo(CensusData input) {
		cd = input;
	}
	
	// read in the data from the given file and preprocess it,
	// depending on which version of the algorithm is specified
    public void preprocess(int x, int y) {
	
		maxX=x;
		maxY=y;
	
		ForkJoinPool fjp = new ForkJoinPool();	
		Corner usaCorner = fjp.invoke(new CornerTask(cd.data, 0, cd.data_size));
		usaRect = usaCorner.rect;
		totalPop = usaCorner.population;
	
		minLon=usaRect.left;
		maxLon=usaRect.right;
		maxLat=usaRect.top;
		minLat=usaRect.bottom;
		
		//Determine grid increments
		gridHeight = Math.abs((minLat-maxLat)/y);
		gridWidth = Math.abs((minLon-maxLon)/x);
	
	}

	// answer a query rectangle by providing the population in that region
	// as well as the percentage this represents of the total U.S. population
    public Pair<Integer, Float> singleInteraction(int w, int s, int e, int n) {
	
		Rectangle rect = new Rectangle(w, e, n, s);
		int pop=0;
		Corner corn = new Corner(rect, pop);
		Grid initG = new Grid(corn, minLon, minLat, gridWidth, gridHeight, maxX, maxY);
		
		ForkJoinPool fjp = new ForkJoinPool();	
		Grid usaGrid = fjp.invoke(new QueryTask(cd.data, 0, cd.data_size, initG));
				
		pop=usaGrid.corn.population;

		return new Pair<Integer, Float>(new Integer(pop), new Float((float)(pop)/(float)(totalPop)*100));

	}


}