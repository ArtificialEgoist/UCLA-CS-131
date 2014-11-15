//Nathan Tung (004-059-195)
//Resources Used: Java List APIs, Anonymous Classes (link provided in project specs)


// import lists and other data structures from the Java standard library
import java.util.*;

// a type for arithmetic expressions
interface AExp {
    double eval(); 	                       // Problem 1a
    List<Sopn> toRPN(); 	               // Problem 1c
    Pair<List<Sopn>,Integer> toRPNopt();    // Problem 1d
}

// a representation of four arithmetic operators
enum Op {
    PLUS { public double calculate(double a1, double a2) { return a1 + a2; } },
    MINUS { public double calculate(double a1, double a2) { return a1 - a2; } },
    TIMES { public double calculate(double a1, double a2) { return a1 * a2; } },
    DIVIDE { public double calculate(double a1, double a2) { return a1 / a2; } };

    abstract double calculate(double a1, double a2);
}

class Num implements AExp {
	double val;
	
	Num(double i) { val=i; } 
			
	public double eval() {
		return val;
	}
	
	public List<Sopn> toRPN() {
		List<Sopn> ans = new ArrayList<Sopn>();
		Sopn x = new Push(val);
		ans.add(x);
		return ans;
	}
	
	public Pair<List<Sopn>,Integer> toRPNopt() {
		List<Sopn> expr = new ArrayList<Sopn>();
		expr.add(new Push(val));
		
		return new Pair<List<Sopn>,Integer>(expr,new Integer(1));
	}
}

class BinOp implements AExp {
	AExp val1;
	AExp val2;
	Op op;
	
	BinOp(AExp a, Op c, AExp b) {
		val1=a;
		val2=b;
		op=c;
	}
	
	public double eval() {
		return op.calculate(val1.eval(), val2.eval());
	}
	
	public List<Sopn> toRPN() {
		List<Sopn> ans = new ArrayList<Sopn>();
		
		List<Sopn> rpn1 = val1.toRPN();
		List<Sopn> rpn2 = val2.toRPN();
		
		for (Sopn rpn : rpn1)
			ans.add(rpn);
			
		for (Sopn rpn : rpn2)
			ans.add(rpn);
				
		ans.add(new Calculate(op));
		
		return ans;
	}
	
	public Pair<List<Sopn>,Integer> toRPNopt() {
		List<Sopn> expr = new ArrayList<Sopn>();
		Pair<List<Sopn>,Integer> ans;
		
		Pair<List<Sopn>,Integer> rpn1 = val1.toRPNopt(); //recursively find optimal solutions for both left/right expressions
		Pair<List<Sopn>,Integer> rpn2 = val2.toRPNopt();
		
		if(rpn2.snd() > rpn1.snd()) { //if the second expression uses more stack space, move it to the front to minimize further stack use
			for(Sopn x : rpn2.fst()) //add the more costly expression first
				expr.add(x);
			for(Sopn x : rpn1.fst())
				expr.add(x);
				
			if(op==Op.MINUS || op==Op.DIVIDE)
				expr.add(new Swap());
				
			expr.add(new Calculate(op));
			ans = new Pair<List<Sopn>,Integer>(expr,rpn2.snd()); //combine expressions and return max size (that is, space used by rpn2)
		}
		else if(rpn1.snd().equals(rpn2.snd())) {
		
			for(Sopn x : rpn1.fst())
				expr.add(x);
			for(Sopn x : rpn2.fst())
				expr.add(x);
			
			expr.add(new Calculate(op));
			
			if(rpn1.snd().equals(1)) //we know rpn1.snd() is 1 and rpn2.snd() are both 1, so max space used thus far is 2
				ans = new Pair<List<Sopn>,Integer>(expr,2); //combine the expressions and return the minimal max stack size
			else //since they're equal, the resulting equation will have the same stack space plus one 
				ans = new Pair<List<Sopn>,Integer>(expr,rpn1.snd()+1);
				
		}
		else { //if the first expression uses more or equal stack space as the second, we use default left to right order
			//this case includes our base case of two standalone doubles
			for(Sopn x : rpn1.fst())
				expr.add(x);
			for(Sopn x : rpn2.fst())
				expr.add(x);
			
			expr.add(new Calculate(op));
			ans = new Pair<List<Sopn>,Integer>(expr,rpn1.snd()); //combine the expressions and return the minimal max stack size
		}
		return ans;
	}
}

// a type for stack operations
interface Sopn {
	void doInstr(Stack<Double> stack);
	String toString();
}

class Push implements Sopn {

	double val;
	
	Push(double i) { val=i; }
	
	public void doInstr(Stack<Double> stack) {
		stack.push(val);
	}
	
	public String toString() {
		return "Push " + val;
	}
}

class Swap implements Sopn {
	public void doInstr(Stack<Double> stack) {
		Double first = stack.pop();
		Double second = stack.pop();
		stack.push(first);
		stack.push(second);
	}
	
	public String toString() {
		return "Swap";
	}
}

class Calculate implements Sopn {
	Op op;
	
	Calculate(Op i) { op=i; }
	
	public void doInstr(Stack<Double> stack) {
		stack.push(op.calculate(stack.pop(),stack.pop()));
	}
	
	public String toString() {
		return "Calculate " + op;
	}
}

// an RPN expression is essentially a wrapper around a list of stack operations
class RPNExp {
    protected List<Sopn> instrs;

    public RPNExp(List<Sopn> instrs) { this.instrs = instrs; }

    public double eval() {
		
		Stack<Double> nums = new Stack<Double>();
		
		for( Sopn sopn : instrs)
		{
			sopn.doInstr(nums);
		}
		
		return nums.pop();
	}  // Problem 1b	
}

class Pair<A,B> {
    protected A fst;
    protected B snd;

    Pair(A fst, B snd) { this.fst = fst; this.snd = snd; }

    A fst() { return fst; }
    B snd() { return snd; }
}


class CalcTest {
    public static void main(String[] args) {
	
	// a test for Problem 1a
	 AExp aexp = new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)), Op.TIMES, new Num(3.0));
	 System.out.println("aexp evaluates to " + aexp.eval()); // aexp evaluates to 9.0

	// a test for Problem 1b
	List<Sopn> instrs = new LinkedList<Sopn>();
	instrs.add(new Push(1.0));
	instrs.add(new Push(2.0));
	instrs.add(new Calculate(Op.PLUS));
	instrs.add(new Push(3.0));
	instrs.add(new Swap());
	instrs.add(new Calculate(Op.TIMES));
	RPNExp rpnexp = new RPNExp(instrs);
	System.out.println("rpnexp evaluates to " + rpnexp.eval());  // rpnexp evaluates to 9.0

	// a test for Problem 1c
	System.out.println("aexp converts to " + aexp.toRPN());

	// a test for Problem 1d
	AExp aexp2 = new BinOp(new Num(1.0), Op.MINUS, new BinOp(new Num(2.0), Op.PLUS, new Num(3.0)));
	System.out.println("aexp2 optimally converts to " + aexp2.toRPNopt().fst() + " with #" + aexp2.toRPNopt().snd());
    }
}


interface Dict<K,V> {
    void put(K k, V v);
    V get(K k) throws NotFoundException;
}

class NotFoundException extends Exception {}

class DictImpl2<K,V> implements Dict<K,V> {
    protected Node<K,V> root;

    DictImpl2() { root = new Empty<K,V>(); }

    public void put(K k, V v) { root = new Entry<K,V>(k,v,root); }

    public V get(K k) throws NotFoundException { return root.fetch(k); }
}

interface Node<K,V> {
	V fetch(K x) throws NotFoundException;
}

class Empty<K,V> implements Node<K,V> {
    Empty() {}
	public V fetch(K x) throws NotFoundException {
		throw new NotFoundException();
	}
}

class Entry<K,V> implements Node<K,V> {
    protected K k;
    protected V v;
    protected Node<K,V> next;

    Entry(K k, V v, Node<K,V> next) {
	this.k = k;
	this.v = v;
	this.next = next;
    }
	
	public V fetch(K x) throws NotFoundException {
		if(k.equals(x))
			return v;
		else
			return next.fetch(x);
	}
}

interface DictFun<A,R> {
    R invoke(A a) throws NotFoundException;
}

class DictImpl3<K,V> implements Dict<K,V> {
    protected DictFun<K,V> dFun;

	class newFun<A,R> implements DictFun<A,R> {
		A aVal;
		R rVal;
		DictFun<A,R> nextFun;
		boolean isEmpty=false;
		
		newFun() { isEmpty=true; }
		
		newFun(A a, R r, DictFun<A,R> next) {
			aVal=a;
			rVal=r;
			nextFun=next;
		}
		public R invoke(A a) throws NotFoundException {
			if(isEmpty)
				throw new NotFoundException();
			else if(a.equals(aVal))
				return rVal;
			else
				return nextFun.invoke(a);
		}
	}
	
    DictImpl3() {
		dFun = new newFun<K,V>();
	}

    public void put(K k, V v) {
		dFun = new newFun<K,V>(k,v,dFun);
	}

    public V get(K k) throws NotFoundException { return dFun.invoke(k); }
}


class DictTest {
    public static void main(String[] args) {

	    // a test for Problem 2a
	Dict<String,Integer> dict1 = new DictImpl2<String,Integer>();
	dict1.put("hello", 23);
	dict1.put("bye", 45);
	try {
	    System.out.println("bye maps to " + dict1.get("bye")); // prints 45
	    System.out.println("hi maps to " + dict1.get("hi"));  // throws an exception
	} catch(NotFoundException e) {
	    System.out.println("not found!");  // prints "not found!"
	}
	
	// a test for Problem 2b
	Dict<String,Integer> dict2 = new DictImpl3<String,Integer>();
	dict2.put("hello", 23);
	dict2.put("bye", 45);
	try {
	    System.out.println("bye maps to " + dict2.get("bye"));  // prints 45
		System.out.println("hello maps to " + dict2.get("hello"));  // prints 23
		System.out.println("hi maps to " + dict2.get("hi"));   // throws an exception 
	} catch(NotFoundException e) {
	    System.out.println("not found!");  // prints "not found!"
	}
    }
}

class CalcTest2 {
    public static void main(String[] args) {
	
	//1A
	AExp aexp = new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)), Op.TIMES, new Num(3.0));
	AExp aexp2 = new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)), Op.DIVIDE, new Num(3.0));
	AExp aexp3 = new BinOp(new BinOp(new Num(1.0), Op.MINUS, new Num(2.0)), Op.TIMES, new Num(3.0));
	AExp aexp4 = new Num(1.0);
	AExp aexp5 = new BinOp(new Num(1.0), Op.DIVIDE, new Num(2.0));
	
	System.out.println(aexp.eval()==9.0); // aexp evaluates to 9.0
	System.out.println(aexp2.eval()==1.0);
	System.out.println(aexp3.eval()==-3.0);
	System.out.println(aexp4.eval()==1.0);
	System.out.println(aexp5.eval()==0.5);

	//1B
	List<Sopn> instrs = new LinkedList<Sopn>();
	instrs.add(new Push(1.0));
	instrs.add(new Push(2.0));
	instrs.add(new Calculate(Op.PLUS));
	instrs.add(new Push(3.0));
	instrs.add(new Swap());
	instrs.add(new Calculate(Op.TIMES));
	RPNExp rpnexp = new RPNExp(instrs);
	System.out.println(rpnexp.eval()==9.0);  // rpnexp evaluates to 9.0
		
	List<Sopn> instrs2 = new LinkedList<Sopn>();
	instrs2.add(new Push(1.0));
	instrs2.add(new Push(2.0));
	instrs2.add(new Calculate(Op.PLUS));
	instrs2.add(new Push(3.0));
	instrs2.add(new Calculate(Op.DIVIDE));
	RPNExp rpnexp2 = new RPNExp(instrs2);
	System.out.println(rpnexp2.eval()==1.0); 
	
	List<Sopn> instrs3 = new LinkedList<Sopn>();
	instrs3.add(new Push(1.0));
	instrs3.add(new Push(2.0));
	instrs3.add(new Swap());
	instrs3.add(new Calculate(Op.MINUS));
	instrs3.add(new Push(3.0));
	instrs3.add(new Calculate(Op.TIMES));
	RPNExp rpnexp3 = new RPNExp(instrs3);
	System.out.println(rpnexp3.eval()==-3.0); 	
	
	List<Sopn> instrs31 = new LinkedList<Sopn>();
	instrs31.add(new Push(1.0));
	instrs31.add(new Push(2.0));
	instrs31.add(new Calculate(Op.MINUS));
	instrs31.add(new Push(3.0));
	instrs31.add(new Swap());
	instrs31.add(new Calculate(Op.TIMES));
	RPNExp rpnexp31 = new RPNExp(instrs31);
	System.out.println(rpnexp31.eval()==3.0);
	
	List<Sopn> instrs4 = new LinkedList<Sopn>();
	instrs4.add(new Push(1.0));
	RPNExp rpnexp4 = new RPNExp(instrs4);
	System.out.println(rpnexp4.eval()==1.0); 	
	
	List<Sopn> instrs5 = new LinkedList<Sopn>();
	instrs5.add(new Push(1.0));
	instrs5.add(new Push(2.0));
	instrs5.add(new Calculate(Op.DIVIDE));
	RPNExp rpnexp5 = new RPNExp(instrs5);
	System.out.println(rpnexp5.eval()==2.0); 	
	
	//1C
	System.out.println("aexp converts to " + aexp.toRPN());
	System.out.println("aexp2 converts to " + aexp2.toRPN());
	System.out.println("aexp3 converts to " + aexp3.toRPN());
	System.out.println("aexp4 converts to " + aexp4.toRPN());
	System.out.println("aexp5 converts to " + aexp5.toRPN());

	//1D
	AExp aexp0 = new BinOp(new Num(1.0), Op.PLUS, new BinOp(new Num(2.0), Op.PLUS, new Num(3.0)));
	System.out.println("aexp0 optimally converts to " + aexp0.toRPNopt().fst() + " with #" + aexp0.toRPNopt().snd());
	
	AExp aexp1 = new BinOp(new Num(1.0), Op.MINUS, new BinOp(new Num(2.0), Op.PLUS, new Num(3.0)));
	System.out.println("aexp1 optimally converts to " + aexp1.toRPNopt().fst() + " with #" + aexp1.toRPNopt().snd());
	
	System.out.println("aexp2: " + aexp2.toRPNopt().fst() + " with #" + aexp2.toRPNopt().snd());
	System.out.println("aexp3: " + aexp3.toRPNopt().fst() + " with #" + aexp3.toRPNopt().snd());
	System.out.println("aexp4: " + aexp4.toRPNopt().fst() + " with #" + aexp4.toRPNopt().snd());
	System.out.println("aexp5: " + aexp5.toRPNopt().fst() + " with #" + aexp5.toRPNopt().snd());
	
	AExp aexp6 = new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)), Op.DIVIDE, new BinOp(new Num(3.0), Op.PLUS, new Num(4.0)));
	
	System.out.println("aexp6: " + aexp6.toRPNopt().fst() + " with #" + aexp6.toRPNopt().snd());
	
	AExp aexp7 = new BinOp(aexp6, Op.PLUS, aexp6);
	System.out.println("aexp7: " + aexp7.toRPNopt().fst() + " with #" + aexp7.toRPNopt().snd());
	
    }
}

class DictTest2 {
    public static void main(String[] args) {

	    // a test for Problem 2a
	Dict<String,Integer> dict1 = new DictImpl2<String,Integer>();
	
	try {
	    System.out.println("bye maps to " + dict1.get("bye")); // prints 45
	} catch(NotFoundException e) {
	    System.out.println("not found!");  // prints "not found!"
	}
	
	dict1.put("hello", 23);
	
	try { System.out.println(dict1.get("hello")==23);  // prints 23	
	} catch(NotFoundException e) { System.out.println("not found!"); }	
	

	dict1.put("bye", 45);
	dict1.put("hello",32);
	
	try { System.out.println(dict1.get("hello")==32);
	} catch(NotFoundException e) { System.out.println("not found!"); }	
	
	try { System.out.println(dict1.get("bye")==45);
	} catch(NotFoundException e) { System.out.println("not found!"); }	
		
	try {
	    System.out.println("hi maps to " + dict1.get("hi"));  // throws an exception
	} catch(NotFoundException e) {
	    System.out.println("not found!");  // prints "not found!"
	}
	
	// a test for Problem 2b
	Dict<String,Integer> dict2 = new DictImpl3<String,Integer>();

	dict2.put("hello", 23);
	
	try { System.out.println(dict2.get("hello")==23); 
	} catch(NotFoundException e) { System.out.println("not found!"); }	
	
	dict2.put("bye", 45);
	dict2.put("hello",32);
	
	try { System.out.println(dict2.get("hello")==32);
	} catch(NotFoundException e) { System.out.println("not found!"); }	
	
	try { System.out.println(dict2.get("bye")==45);
	} catch(NotFoundException e) { System.out.println("not found!"); }	
	
	try {
		System.out.println("hi maps to " + dict2.get("hi"));   // throws an exception 
	} catch(NotFoundException e) {
	    System.out.println("not found!");  // prints "not found!"
	}
    }
}

class CalcTest3 {

	public static void main(String[] args) {
		AExp aexp = new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)),
		Op.TIMES,new Num(3.0));
		AExp aexp1 =
		new BinOp(new Num(1.0), Op.PLUS, new BinOp(new Num(2.0), Op.PLUS, new BinOp(new Num(3.0), Op.PLUS, new Num(4.0))));
		AExp aexp2 =
		new BinOp(new Num(1.0), Op.MINUS, new BinOp(new Num(2.0), Op.PLUS, new Num(3.0)));
		AExp aexp3 =
		new BinOp(new BinOp(new Num(2.0), Op.PLUS, new Num(3.0)), Op.MINUS, new BinOp(new Num(2.0), Op.PLUS, new Num(3.0)));
		System.out.println("aexp optimally converts to " + aexp.toRPNopt().fst());
		System.out.println("aexp optimally Stack requirement is " + aexp.toRPNopt().snd());
		System.out.println("aexp1 optimally converts to " + aexp1.toRPNopt().fst());
		System.out.println("aexp1 optimally Stack requirement is " + aexp1.toRPNopt().snd());
		System.out.println("aexp2 optimally converts to " + aexp2.toRPNopt().fst());
		System.out.println("aexp2 optimally Stack requirement is " + aexp2.toRPNopt().snd());
		System.out.println("aexp3 optimally converts to " + aexp3.toRPNopt().fst());
		System.out.println("aexp3 optimally Stack requirement is " + aexp3.toRPNopt().snd());

		/*
		aexp optimally converts to [Push 1.0, Push 2.0, Calculate PLUS, Push 3.0, Calculate TIMES]
		aexp optimally Stack requirement is 2
		aexp1 optimally converts to [Push 3.0, Push 4.0, Calculate PLUS, Push 2.0, Calculate PLUS, Push 1.0, Calculate PLUS]
		aexp1 optimally Stack requirement is 2
		aexp2 optimally converts to [Push 2.0, Push 3.0, Calculate PLUS, Push 1.0, Swap,Calculate MINUS]
		aexp2 optimally Stack requirement is 2
		aexp3 optimally converts to [Push 2.0, Push 3.0, Calculate PLUS, Push 2.0, Push 3.0, Calculate PLUS, Calculate MINUS]
		aexp3 optimally Stack requirement is 3
		*/
	}

}