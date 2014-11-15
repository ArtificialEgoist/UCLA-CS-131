import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.util.Scanner;

class GridTask extends RecursiveTask<int[][]> {
	
	private final CensusGroup[] arr;
	private final int start, end;
	private static final int SEQUENTIAL_THRESHOLD = 100;
	private Rectangle rect;
	private int x, y;
	private float maxLat, minLat, maxLon, minLon, gridHeight, gridWidth;
	
	public GridTask(CensusGroup[] arr, int start, int end, Rectangle r, int x, int y) {
		this.arr=arr;
		this.start=start;
		this.end=end;
		this.rect=r;
		this.x=x;
		this.y=y;
		
		maxLat = rect.top;
		minLat = rect.bottom;
		maxLon = rect.right;
		minLon = rect.left;		
		
		gridHeight = Math.abs((minLat-maxLat)/y);
		gridWidth = Math.abs((minLon-maxLon)/x);
	}
	
	public int[][] compute() {
		int[][] grid = new int[x][y];
		int length = end-start; //find length of array
		if (length<SEQUENTIAL_THRESHOLD) //solve sequentially
		{
			for(int i = start; i < end; i++)
			{
				CensusGroup cg = arr[i];
			
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
			return grid;
		}
		
		int mid = (start+end)/2;
		
		GridTask left = new GridTask(arr, start, mid, rect, x, y);
		GridTask right = new GridTask(arr, mid, end, rect, x, y);
		left.fork();
		int[][] second = right.compute();
		int[][] first = left.join();

		//Combine population count in grids
		for(int i=0; i<first.length; i++)
			for(int j=0; j<first[0].length; j++)
				first[i][j]+=second[i][j];
		
		return first;
	}
}

public class VersionFour extends VersionTwo implements VersionObject {

	private Rectangle usaRect;
	private int totalPop=0;
	private CensusData cd;
	private float maxLat, minLat, maxLon, minLon, gridHeight, gridWidth;
	private int[][] grid; 
		
	//construct VersionObject with some CensusData
	public VersionFour(CensusData input) {
		super(input);
		cd = input;
	}
	
	// read in the data from the given file and preprocess it,
	// depending on which version of the algorithm is specified
    public void preprocess(int x, int y) {
	
		//Create the xy grid
		grid = new int[x][y];

		//Use parallelism to determine the corners and total population
		ForkJoinPool fjp = new ForkJoinPool();	
		Corner c = fjp.invoke(new CornerTask(cd.data, 0, cd.data_size));
		usaRect = c.rect;
		totalPop = c.population;
	
		maxLat = usaRect.top;
		minLat = usaRect.bottom;
		maxLon = usaRect.right;
		minLon = usaRect.left;		
		
		gridHeight = Math.abs((minLat-maxLat)/y);
		gridWidth = Math.abs((minLon-maxLon)/x);
		
		//Use parallelism to generate the grid
		ForkJoinPool fjp2 = new ForkJoinPool();	
		grid = fjp2.invoke(new GridTask(cd.data, 0, cd.data_size, usaRect, x, y));
		
		//Update the grid elements to be cumulative sequentially
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
