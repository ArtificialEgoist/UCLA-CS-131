
(* Name:

   UID:

   Others With Whom I Discussed Things:

   Other Resources I Consulted:
   
*)

(* Problem 1a
   fold_left: ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
*)


(* Problem 1b
   flatten: 'a list list -> 'a list
*)
      

(* Problem 1c
   pipe: ('a -> 'a) list -> ('a -> 'a)
*)
  

(* Problem 1d
   swap: ('a -> 'b -> 'c) -> ('b -> 'a -> 'c)
*)   
    
    
(* Problem 2a
   put1: 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
   get1: 'a -> ('a * 'b) list -> 'b option
*)  
  

(* Problem 2b
   put2: string -> int -> dict2 -> dict2
   get2: string -> dict2 -> int option
*)  
    
type dict2 = Empty | Entry of string * int * dict2


(* Problem 2c
   put3: string -> int -> dict3 -> dict3
   get3: string -> dict3 -> int option
*)  

type dict3 = Dict3 of (string -> int option)


(* Problem 3a
   evalAExp: aexp -> float
*)

type op = Plus | Minus | Times | Divide
type aexp = Num of float | BinOp of aexp * op * aexp


(* Problem 3b
   evalRPN: sopn list -> float
*)

type sopn = Push of float | Swap | Calculate of op


(* Problem 3c
   toRPN: aexp -> sopn list
*)


(* Problem 3d
   fromRPN: sopn list -> aexp
*)

