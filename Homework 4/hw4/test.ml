
(* A simple test harness for the MOCaml interpreter. *)

(* put your tests for the eval function here:
   each test is a pair of a MOCaml expression and the expected
   result value after evaluation, both expressed as strings.
   use the string "DynamicTypeError" if a DynamicTypeError is expected to be raised.
   use the string "MatchFailure" if a MatchFailure is expected to be raised.
   use the string "ImplementMe" if an ImplementMe exception is expected to be raised

   call the function testEval() to run these tests
*)
let evalTests = [("3", "3");
		 ("true", "true");
		 ("let (x:int) = 4 in x+5", "9");
		 ("true + 4", "DynamicTypeError");
		 ("let ((x:int),(y:int)) = (3,4) in x+y", "7")]

(* put your tests for the typecheck function here:
   each test is a pair of an input expression and the expected
   result type from typechecking, both expressed as strings.
   use the string "StaticTypeError" if a StaticTypeError is expected to be raised.
   use the string "ImplementMe" if an ImplementMe exception is expected to be raised 

   call the function testTypecheck() to run these tests
*)
let typecheckTests = [("3", "int");
	       ("true", "bool");
	       ("let (x:int) = 4 in x+5", "int");
	       ("true + 4", "StaticTypeError")]

  
(* The Test Harness *)	  
  
let testOne (test, expectedResult)  testF =
  try
    let expr = main token (Lexing.from_string (test^";;")) in
    testF expr
  with
      Parsing.Parse_error -> "parse error"

let testF f e =
  try
    f e
  with
      DynamicTypeError -> "DynamicTypeError"
    | MatchFailure -> "MatchFailure"
    | StaticTypeError -> "StaticTypeError"
    | ImplementMe s -> "ImplementMe"
      
let test f tests =
  let results =
    List.map
      (function pair -> testOne pair (testF f))
      tests
  in
  List.iter2
    (fun (t,er) r ->
      let out = if er=r then "ok" else "expected " ^ er ^ " but got " ^ r in
      print_endline
	(t ^ "....................." ^ out))
      tests results

(* CALL THESE FUNCTIONS TO RUN THE TESTS *)
let testEval () = test (fun e -> print_val (eval e (Env.empty_env()))) evalTests
let testTypecheck () = test (fun e -> print_typ (typecheck e (Env.empty_env()))) typecheckTests
  
