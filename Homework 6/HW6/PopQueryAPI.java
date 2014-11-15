
public interface PopQueryAPI {
	// read in the data from the given file and preprocess it,
	// depending on which version of the algorithm is specified
    public void preprocess(String filename, int x, int y, int versionNum);

	// answer a query rectangle by providing the population in that region
	// as well as the percentage this represents of the total U.S. population
    public Pair<Integer, Float> singleInteraction(int w, int s, int e, int n);
}