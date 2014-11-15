

(* EXCEPTIONS *)

(* This is a marker for places in the code that you have to fill in.
   Your completed assignment should never raise this exception. *)
exception ImplementMe of string

(* This exception is thrown when a type error occurs during evaluation
   (e.g., attempting to invoke something that's not a function).
*)
exception DynamicTypeError

(* This exception is thrown when pattern matching fails during evaluation. *)  
exception MatchFailure  

(* This exception is thrown to indicate an error during static typechecking
   (e.g., a name has not been declared before it is used).
*)
exception StaticTypeError

  
(* Evaluate an expression in the given environment.  Raise a MatchFailure if
   pattern matching fails.  Raise a DynamicTypeError if any other kind of error
   occurs (e.g., trying to add a boolean to an integer) which prevents evaluation
   from continuing.
*)	      
let rec eval (e:moexpr) (env:moenv) : movalue =
  raise (ImplementMe "evaluation not implemented")


(* Typecheck an expression in the given type environment. Raise a StaticTypeError
   if a type error is found (e.g., trying to use an expression of type bool
   as if it has type int). *)    
let rec typecheck (e:moexpr) (tenv:motenv) :motyp =
  raise (ImplementMe "static typechecking not implemented")
