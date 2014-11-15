(* Name: Nathan Tung

   UID: 004-059-195

   Others With Whom I Discussed Things: N/A

   Other Resources I Consulted: looked at higher-order list functions
	(http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html)
   
*)

(* Problem 1a
   fold_left: ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
*)

let rec fold_left f b l =
	match l with
		[] -> b (* if list is empty, return the base case *)
		| x::xs -> fold_left f (f b x) xs;; (* otherwise, recursively run fold_left with new base case of function x *)

(* Problem 1b
   flatten: 'a list list -> 'a list
*)
      
let flatten l =
	List.fold_right (fun x y -> x@y) l [];; (* use fold_right to run concat function on last to first list elements *)
	  
(* Problem 1c
   pipe: ('a -> 'a) list -> ('a -> 'a)
*)
  
let pipe f x =
	List.fold_left (fun m n -> n m) x f;; (* use fold_left to run the list of functions f as input, 
	then use the created function to flip instances of f with base x such that we run fn(...f2(f1(x))) *)

(* Problem 1d
   swap: ('a -> 'b -> 'c) -> ('b -> 'a -> 'c)
*)   

let swap f x y = 
	f y x;; (* run the function given by f with parameters swapped; results remain the same *)
    
(* Problem 2a
   put1: 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
   get1: 'a -> ('a * 'b) list -> 'b option
*)  

let put1 k v l = 
	(k,v)::l;; (* add some key-value pair - a tuple - into the list passed in *)

let get1 k l = 
	List.fold_right
		(fun x y -> match x with
		(k1,v1) -> if k=k1 then Some v1 else y) l None;; (* use fold_right to check if any keys match
		starting from end of list; returns the farthest left value with matching key or returns base case None *)

(* Problem 2b
   put2: string -> int -> dict2 -> dict2
   get2: string -> dict2 -> int option
*)  
    
type dict2 = Empty | Entry of string * int * dict2

let put2 k v d = 
	Entry(k,v,d);; (* create a new instance of dict2 type Entry with key, value, and the passed in dict2 *)

let rec get2 k d = 
	match d with
	Empty -> None (* if dict2 is empty, there's no key, so return None *)
	| Entry(x,y,z) -> if k=x then Some y else get2 k z;; (* otherwise, check key-value in next embedded dict, etc. *)

(* Problem 2c
   put3: string -> int -> dict3 -> dict3
   get3: string -> dict3 -> int option
*)  

type dict3 = Dict3 of (string -> int option)

let put3 k v d = 
	Dict3(fun s-> if s=k then Some v else match d with Dict3(z) -> z s);;
	(* create dict3 type with function that matches k to v; otherwise, it's passed into the previous function *)
			
let rec get3 k d = 
	match d with
	Dict3(z) -> z k;; (* match dict3 with function inside; run the function on the key to check for value, if any *)

(* Problem 3a
   evalAExp: aexp -> float
*)

type op = Plus | Minus | Times | Divide
type aexp = Num of float | BinOp of aexp * op * aexp

let rec evalAExp x = 
	match x with
	Num f -> f (* if the aexp passed in is just a Num(float), return the float by itself *)
	| BinOp(a,o,b) -> (* otherwise, it is a BinOp; we recursively run evalAExp on the two aexp, then run an operator*)
		let c = evalAExp(a) in (* use local variables to store the evaluated result of each aexp in BinOp *)
		let d = evalAExp(b) in
		match o with (* perform float arithmetic according to operation op *)
		Plus -> c+.d
		| Minus -> c-.d
		| Times -> c*.d
		| Divide -> c/.d;;

(* Problem 3b
   evalRPN: sopn list -> float
*)

type sopn = Push of float | Swap | Calculate of op

let evalRPN s =
	let rec helpRPN sList fList = (* helper function: sopn list -> float list -> float*)
		match sList with
		[] -> (match fList with x::xs -> x) (* if there are so sopn operations, return the single float in list *)
		| (Push f)::ss -> helpRPN ss (f::fList) (* if there is a push operation, add that float to list and rerun help *)
		| (Swap)::ss -> (match fList with x1::x2::xs -> helpRPN ss (x2::x1::xs)) (* if swap, swap first two floats in list *)
		| (Calculate o)::ss -> match fList with x1::x2::xs -> (* to calculate, separate out first two floats in list *)
			match o with (* do floating arithmetic based on op on x1, x2; place this back in list and rerun help *)
			Plus -> helpRPN ss (x2+.x1::xs) (* flip operands according to specs, as x1 is the 2nd operand (first to be popped) *)
			| Minus -> helpRPN ss (x2-.x1::xs)
			| Times -> helpRPN ss (x2*.x1::xs)
			| Divide -> helpRPN ss (x2/.x1::xs)
in helpRPN s [];; (* pass in entire sopn list along with an empty list of floats for helper function to store data *)

(* Problem 3c
   toRPN: aexp -> sopn list
*)

let toRPN x =
	let rec helpToRPN y sList = (* helper function: aexp -> sopn list *)
		match y with
		Num f -> sList@[(Push f)] (* if only some Num(float) is left in aexp, add command to Push float into list at end *)
		| BinOp(a,o,b) -> (helpToRPN b (helpToRPN a sList))@[(Calculate o)] (* otherwise, run help on both the Num(float) values
			then concat the operator command to the end of the list; results in olderlist with a, b, and o added to the right *)
in helpToRPN x [];; (* pass in aexp along with an empty list of sopn for helper function to build onto and return *)

(* Problem 3d
   fromRPN: sopn list -> aexp
*)

let fromRPN s = 
	let rec helpFromRPN sList x = (* helper function: sopn list -> aexp *)
		match sList with
		[] -> x (* if no sopn commands, return whatever aexp we have *)
		| (Push a)::[] -> Num a (* if single Push(float) sopn remains, return that float as aexp *)
		| (Push a)::(Calculate o)::ss -> helpFromRPN ss (BinOp(x,o,Num a)) (* calculate aexps (parameter x and popped-off a) 
			using operator o, then pass that in as new aexp parameter with the rest of the sopn list to help function again*)
		| (Push a)::Swap::(Calculate o)::ss -> helpFromRPN ss (BinOp(Num a,o,x)) (* if swap encountered, change operation order *)
in match s with
	(Push a)::[] -> Num a
	| (Push a)::(Push b)::(Calculate o)::ss -> helpFromRPN ss (BinOp(Num a,o,Num b)) (* initialize by calculating the first conditions *)
	|(Push a)::(Push b)::Swap::(Calculate o)::ss -> helpFromRPN ss (BinOp(Num b,o,Num a));; (* account for initial swap *)