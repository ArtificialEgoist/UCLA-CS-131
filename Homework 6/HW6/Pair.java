

// a pair of a T and an S
public class Pair<T,S> {
    private T fst;
    private S snd;
    
    public Pair(T elt1, S elt2){
	this.fst = elt1;
	this.snd = elt2;
    }
    
    public T fst(){
	return fst;
    }
    public S snd(){
	return snd;
    }
}
