(*
 * Based on code by Chris Stone and Stephen Freund
 *)

module Expr1 = struct

  type t = 
      X
    | Y
    | Sin      of t
    | Cos      of t
    | Avg      of t * t
    | Mult     of t * t

  (* the mathematical constant pi *)
  let pi = 4. *. atan 1.

  (* Expression creation *)
  let buildX = X
  let buildY = Y
  let buildSin e = Sin e
  let buildCos e = Cos e
  let buildAvg (e1,e2) = Avg(e1,e2)
  let buildMult (e1,e2) = Mult(e1,e2)


  (* exprToString : t -> string *)
  let rec exprToString e = match e with
	X -> "x"
      | Y -> "y"
      | Sin e -> "sin(pi*"^exprToString(e)^")"
      | Cos e -> "cos(pi*"^exprToString(e)^")"
      | Avg(e1, e2) ->
	"("^exprToString(e1)^"+"^exprToString(e2)^")/2.0"
      | Mult(e1, e2) ->
	exprToString(e1)^"*"^exprToString(e2)

	  
  (* eval : t -> float*float -> float
     Evaluate an expression for the given (x,y) coordinate.
  *)
  let rec eval e (x,y) = 
	match e with (* use pattern matching to determine the foremost function *)
		X -> x (* use the function on the recursively-evaluated inner functions *)
		| Y -> y
		| Sin es -> sin(pi *. (eval es (x,y)) )
		| Cos es  -> cos(pi *. (eval es (x,y)) )
		| Avg (e1,e2) -> 0.5 *. ( (eval e1 (x,y)) +. (eval e2 (x,y)) )
		| Mult (e1,e2) -> ( (eval e1 (x,y)) *. (eval e2 (x,y)) )

  let sampleExpr =
    buildCos(buildSin(buildMult(buildCos(buildAvg(buildCos(
      buildX),buildMult(buildCos (buildCos (buildAvg
        (buildMult (buildY,buildY),buildCos (buildX)))),
        buildCos (buildMult (buildSin (buildCos
        (buildY)),buildAvg (buildSin (buildX), buildMult
        (buildX,buildX))))))),buildY)));

end
