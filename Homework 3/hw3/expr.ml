(* Signature for expressions in x and y. *)

module type EXPR =

sig

  type t

  (* the mathematical constant pi *)
  val pi: float

  (* Expression creation *)
  val buildX: t
  val buildY: t
  val buildSin: t -> t
  val buildCos: t -> t
  val buildAvg: t*t -> t
  val buildMult: t*t -> t

  (* exprToString : t -> string *)
  val exprToString: t -> string 
	  
  (* eval : t -> float*float -> float
     Evaluate an expression for the given (x,y) coordinate.
  *)
  val eval: t -> float*float -> float
  
  end
