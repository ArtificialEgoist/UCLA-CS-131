(*
 * art.ml
 * Based on code by Chris Stone and Steve Freund
 *)
 
 (*
 Code for Homework #3 in expr.ml, expr1.ml, expr2.ml, and art.ml by Nathan Tung (004-059-195)
 *)

module Art(Exp:EXPR) = struct (* make Art a functor that takes in some EXPR as parameter *)

  (******************* Functions you need to write **********)
    
  (* forLoop: int * int * (int -> unit) -> unit
     Applies the function f to all the integers between low and high
     inclusive; the function returns no useful result; it is used only
     for its side effects (in our case, writing to a file).
  *)
  let rec forLoop (low,high,f) = 
	if low<=high then ((f low);forLoop(low+1,high,f))
	(* if loop isn't done, perform the operation on lower bound, then increment the lower bound *)

  (* build: int > Exp.t 
     Build an expression tree of the given maximum depth.
  *)
  let rec build depth =
	if depth<=0 then let r = Random.int 10 in (* at the last depth, we generate either X or Y with 50% chance each *)
		if r < 5 then Exp.buildX
		else Exp.buildY
	else let r = Random.int 10 in (* for all other depths, perform some function operator on the next lower depth *)
		if r < 2 then Exp.buildSin (build (depth-1))
		else if r < 4 then Exp.buildCos (build (depth-1))
		else if r < 7 then Exp.buildAvg(build (depth-1), build (depth-1))
		else Exp.buildMult(build (depth-1), build (depth-1));;
  

  (********************* Bitmap creation code ***************)

  (*
     You should not have to modify the remaining functions.
  *)
  
  (*
   Converts an integer i from the range [-n,n]
   into a float in [-1,1]
   *)
  let toFloat(i,n) = (float i) /. (float n)
    
  (*
   Converts a float in [-1,1] to an integer in the range [0,255]
   *)
  let toIntensity(z) =
    let round f =
      let c = ceil f in
      truncate(if (c -. f) <= 0.5 then c else c -. 1.)
    in
    round(127.5 +. (127.5 *. z))


  (* Creates a file name for the given parameters. *)
  let artFileName (depth, seed) =
    "art-"^(string_of_int depth)^"-"^(string_of_int seed)

      
  (* emitGrayscale :  ((float * float) -> float) * int * string -> unit
     emitGrayscale(f, n, name) emits the values of the expression f
     (converted to intensity) to a file name.pgm for a 2n+1 by 2n+1 grid of
     points taken from [-1,1] x [-1,1].
 
     You can "man pgm" on the SEAS Unix machines for a full description of
     the file format, but it's essentially a one-line header followed by
     one byte (representing gray value 0..255) per pixel.
   *)
  let emitGrayscale (f,n,name) =
    (* Open the output file and write the header *)
    let stream = open_out (name ^ ".pgm") in
    set_binary_mode_out stream true;
    (* Picture will be 2*n+1 pixels on a side *)
    let numPixels = n*2+1 in 
    let _ = output_string stream ("P5 " ^ (string_of_int numPixels) ^ " " ^
      (string_of_int numPixels) ^ " 255\n") in
      
    let _ =
      forLoop (-n, n,
               fun ix ->
                 forLoop (-n, n,
                          fun iy ->
                            (* Convert grid locations to [-1,1] *)
                            let x = toFloat(ix,n) in
                            let y = toFloat(iy,n) in
                              
                            (* Apply the given random function *)
                            let z = f(x,y) in
                              
                            (* Convert the result to a grayscale value *)
                            let iz = toIntensity z in
  			    (* Emit one byte for this pixel *)
  			    output_byte stream iz))
    in close_out stream

    
  (* doRandomGray : int * int -> unit
     Given a depth and a seed for the random number generator,
     create a single random expression and convert it to a
     grayscale picture.
   *)
  let doRandomGray (depth,seed) =
        (* Initialize random-number generator g *)
  	let _ = Random.init seed in
        
  	(* Generate a random expression, and turn it into an ML function *)
	let e = build depth in
  	let f = Exp.eval e in
		  
  	(* 301 x 301 pixels *)
  	let n = 150 in
		  
  	let name = artFileName(depth, seed) in
  	print_endline (Exp.exprToString e);
  	(* Emit the picture *)
  	emitGrayscale(f,n,name)

  
  (* emitColor : (float*float->float) * (float*float->float) *
  		 (float*float->float) * int * string -> unit
     emitColor(f1, f2, f3, n, name) emits the values of the expressions
     f1, f2, and f3 (converted to RGB intensities) to the output
     file name.ppm (note the different extension) for a 2n+1 by 2n+1
     grid of points taken from [-1,1] x [-1,1].
 
     The file format is essentially a one-line header followed by
     three bytes (representing red, green, and blue values in the
     range 0..255) per pixel.
   *)
  let emitColor (f1,f2,f3,n,name) =
    let stream = open_out (name^".ppm") in
    set_binary_mode_out stream true;		       

    let numPixels = n*2+1 in
    let _ = output_string stream ("P6 " ^ (string_of_int numPixels) ^ " " ^
  				       (string_of_int numPixels) ^ " 255\n") in
		  
    let _ =
      forLoop (-n, n,
  	       fun ix ->
  		 forLoop (-n, n,
  			  fun iy ->
  			    (* Map grid locations into [-1,1] *)
  			    let x = toFloat(ix,n) in
  			    let y = toFloat(iy,n) in
					  
  			    (* Apply the given random functions *)
  			    let z1 = f1(x,y) in
  			    let z2 = f2(x,y) in
  			    let z3 = f3(x,y) in
			    
  			    (* Convert the result to R, G, and B values *)
  			    let iz1 = toIntensity(z1) in
  			    let iz2 = toIntensity(z2) in
  			    let iz3 = toIntensity(z3) in
  			    (* Emit three bytes for this pixel *)
  			    output_byte stream iz1;
  			    output_byte stream iz2;
  			    output_byte stream iz3))
    in close_out stream
	      
  	 
  (* doRandomColor : int * int -> unit
     Given a depth and a seed for the random number generator,
     create a three random expressions and convert them to a
     color picture.
   *)
  let doRandomColor (depth,seed) =
    (* Initialize random-number generator g *)
    let _ = Random.init seed in
		  
    (* Generate a random expressions, and turn them into ML functions *)
    let e1 = build depth in
    let e2 = build depth in
    let e3 = build depth in
    let f1 = Exp.eval e1 in
    let f2 = Exp.eval e2 in
    let f3 = Exp.eval e3 in
		   
    let _ = (print_string "red   = "; print_endline (Exp.exprToString e1)) in
    let _ = (print_string "green   = "; print_endline (Exp.exprToString e2)) in
    let _ = (print_string "blue   = "; print_endline (Exp.exprToString e3)) in
		  
    (* Open the output file and write the header *)
    let n = 150 in		  
    let name = artFileName(depth,seed) in
    (* Emit the picture *)
    emitColor(f1,f2,f3,n,name)

      
  (* doManyRandom: ((int * int -> unit) * int * int * int) -> unit
     f is intended to be either doRandomGray or doRandomColor above
     Invokes f(depth, seedStart); f(depth, seedStart+1); ... ; f(depth, seedEnd)
  *)   
  let doManyRandom (f, depth, seedStart, seedEnd) =
    forLoop (seedStart, seedEnd, fun s -> f(depth, s))
end



