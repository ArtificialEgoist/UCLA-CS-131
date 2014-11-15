(*
 * Based on code by Chris Stone and Stephen Freund
 *)

module Expr2:EXPR = struct

  type t = float * float -> float

  (* the mathematical constant pi *)
  let pi = 4. *. atan 1.

  (* Expression creation *)
  let buildX (x,y) = x
  let buildY (x,y) = y
  let buildSin f (x,y) = sin (pi *. f(x,y)) (* perform sin operation on pi times the inner function *)
  let buildCos f (x,y) = cos (pi *. f(x,y))
  let buildAvg (f,g) (x,y) = 0.5 *. (f(x,y) +. g(x,y)) (* perform average/mult operations on inner two functions *)
  let buildMult (f,g) (x,y) = f(x,y)*.g(x,y)


  (* exprToString : t -> string *)
  let exprToString _ = "unknown"
	  
  (* eval : t -> float*float -> float
     Evaluate an expression for the given (x,y) coordinate.
  *)
  let eval e (x,y) = 
	e (x,y) (* since expression e is already a valid curried function, we simply call it with base values (x,y) *)
		
(*		
  let sampleExpr =
    buildCos(buildSin(buildMult(buildCos(buildAvg(buildCos(
      buildX),buildMult(buildCos (buildCos (buildAvg
        (buildMult (buildY,buildY),buildCos (buildX)))),
        buildCos (buildMult (buildSin (buildCos
        (buildY)),buildAvg (buildSin (buildX), buildMult
        (buildX,buildX))))))),buildY)));
*)

end