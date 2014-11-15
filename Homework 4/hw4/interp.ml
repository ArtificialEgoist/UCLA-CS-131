

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
	match e with
		IntConst i -> IntVal i
		| BoolConst b -> BoolVal b
		| Var s -> (try Env.lookup s env with Env.NotBound -> raise DynamicTypeError) (* return associated value from env if it exists *)
		| Plus (a,b) -> let (c,d) = (eval a env, eval b env) in
			(match (c,d) with
				(IntVal c, IntVal d) -> IntVal(c+d) (* return some int value if both operands are ints; else give dynamic type error *)
			| _ -> raise DynamicTypeError)
		| If (guard,thn,els) -> (match (eval guard env) with (* make sure guard is a bool *) 
			BoolVal b -> (match b with 
				true -> eval thn env (* return either thn or els *)
				| false -> eval els env
				| _ -> raise DynamicTypeError))
		| Tuple l -> (let rec tEval x =	match x with (* use tEval helper function to return a list with each item evaluated *)
				[] -> []
				| x1::xs -> (eval x1 env)::(tEval xs)
			in TupleVal(tEval l) )
		| Let ((x1,e1),e2) -> (patMatch x1 e1 e2 env) (* call patMatch helper function with passed parameters *)
		| Function (pat,expr) -> FunctionVal (pat,expr,env) (* place function parameters into FunctionVal *)
		| FunctionCall (e1,e2) -> (match (eval e1 env) with (* we can expect expression 1 to be some FunctionVal *)
			FunctionVal(pat,expr,env) -> patMatch pat e2 expr env (* use patMatch to evaluate the function using Let; 
				expression 2 becomes the value used to evaluate expression 1 *)
			| _ -> raise DynamicTypeError)
		| Match (e1,l) -> listMatch e1 l env (* call listMatch helper funtion with passed parameters *)
		| _ -> raise MatchFailure

and patMatch pat expr1 expr2 env = (* main purpose is to evaluate Let *)
	match pat with
		(* given int or bool pattern that does not match expression 1, there is a match failure; else we evaluate expression 2 *)
		IntPat i -> if (IntVal i)=(eval expr1 env) then eval expr2 env else raise MatchFailure
		| BoolPat b -> if (BoolVal b)=(eval expr1 env) then eval expr2 env else raise MatchFailure
		(* we map string to value of expression 1 in the environment, then use that new environment to evaluate expression 2 *)
		| VarPat (str,typ) -> eval expr2 (Env.add_binding str (eval expr1 env) env)
		(* we always evaluate expression 2 unless express 1 has some unbound value; to check, we evaluate it without returning *)
		| WildcardPat typ -> (eval expr1 env);(eval expr2 env)
		(* if we are given a TuplePat of patterns, we can expect expression 1 to be a TupleVal of values *)
		| TuplePat l1 -> let x = eval expr1 env in 
			match x with
				TupleVal l2 -> if (List.length l1)=(List.length l2) (* the two lists must have same length to avoid match failure *)
					then eval expr2 (tupleEnv l1 l2 env) else raise MatchFailure 
					(* we evaluate expression 2 based on the possibility that the environment has changed; use tupleEnv helper *)
				| _ -> raise MatchFailure
		| _ -> raise MatchFailure

and tupleEnv l1 l2 env = (* updates environment based on TuplePat l1 and TupleVal l2 *)
	match l1 with
		[] -> env (* we know the lengths are equal, so if one list runs out, we're done; return the environment *)
		| x::xs -> (match l2 with
			[] -> env
			| y::ys -> (match x with
				(* same as before: check to see if ints or bools match, then continue building env *)
				IntPat i -> if (IntVal i)=y then tupleEnv xs ys env else raise MatchFailure
				| BoolPat b -> if (BoolVal b)=y then tupleEnv xs ys env else raise MatchFailure
				(* wildcard always matches so we continue building env *)
				| WildcardPat typ -> tupleEnv xs ys env
				(* bind string to a value in environment, then continue building env *)
				| VarPat (str,typ) -> tupleEnv xs ys (Env.add_binding str y env)
				(* this means we had a TuplePat in a TuplePat; again, we expect an expression of TupleVal of value list *)
				| TuplePat listPat -> (match y with
					TupleVal listVal -> if (List.length listPat) = (List.length listVal) (* check for list lengths again *)
						(* use this function to recursively find the env of this inner TuplePat, then build onto this env using outer TuplePat *)
						then tupleEnv xs ys (tupleEnv listPat listVal env) else raise MatchFailure
					| _ -> raise MatchFailure)
				| _ -> raise MatchFailure))

and listMatch expr1 l env = (* main purpose is to evaluate Match *)
	match l with
		[] -> raise MatchFailure (* if we have not matched expression 1 with any pattern by the end, there's a MatchFailure *)
		(* for each pattern in list, run patMatch; if they match, expression 2 is evaluated; otherwise, we check next pattern *)
		| (pat,expr2)::xs -> try (patMatch pat expr1 expr2 env) with MatchFailure -> listMatch expr1 xs env
		| _ -> raise MatchFailure
				
(* Typecheck an expression in the given type environment. Raise a StaticTypeError
   if a type error is found (e.g., trying to use an expression of type bool
   as if it has type int). *)    
let rec typecheck (e:moexpr) (tenv:motenv) :motyp =
	match e with
		IntConst i -> IntType
		| BoolConst b -> BoolType
		| Var s -> (try Env.lookup s tenv with Env.NotBound -> raise StaticTypeError) (* check environment for type of s if it exists *)
		| Plus (a,b) -> (match (typecheck a tenv, typecheck b tenv) with (* make sure Plus takes in two IntTypes; returns IntType *)
			(IntType, IntType) -> IntType
			| _ -> raise StaticTypeError)
		| If (guard,thn,els) -> (match (typecheck guard tenv) with (* check that guard has BoolType and the types of thn and els match *)
			BoolType -> let (t1,t2) = (typecheck thn tenv, typecheck els tenv) in
				if t1=t2 then t1 else raise StaticTypeError
			| _ -> raise StaticTypeError)
		| Tuple l -> (match l with (* in the case of a tuple, either it is a UnitType or we use checkTupleType helper with list parameter *)
			[] -> UnitType
			| l -> TupleType (checkTupleType l tenv))
		| Let ((pat,e1),e2) -> patCheck pat e1 e2 tenv (* call patCheck helper function with parameters passed in *)
		| Function (pat,e1) -> functionCheck pat e1 tenv (* call functionCheck helper function with parameters passed in *)
		| FunctionCall (e1,e2) -> (match (typecheck e1 tenv) with (* expression 1 must be a function with arrow type *)
			(* if expression 2 has same type as that of typ1, then we return typ2 *)
			ArrowType(typ1,typ2) -> if (typecheck e2 tenv)=typ1 then typ2 else raise StaticTypeError
			| _ -> raise StaticTypeError)
		| Match (e1,l) -> (match l with (* the pattern-expression list here should be consistent, so we return type of some expression 2 *)
			(pat,e2)::xs -> typecheck e2 tenv
			| _ -> raise StaticTypeError)
		| _ -> raise StaticTypeError

and checkTupleType (l:moexpr list) (tenv:motenv) = (* main purpose is to find a list of types in a Tuple *)
	match l with
		[] -> [] (* no more items means we've typechecked everything *)
		| x::xs -> (typecheck x tenv)::(checkTupleType xs tenv) (* typecheck expression 1; add to front of recursively-typechecked list *)
		| _ -> raise StaticTypeError

and patCheck pat expr1 expr2 tenv = (* main purpose is to pattern check and return type of Let *)
	match pat with
		(* same as before; make sure for ints, bools, and wildcard, the types match expression 1; then return type for expression 2 *)
		IntPat i -> if (typecheck expr1 tenv)=IntType then (typecheck expr2 tenv) else raise StaticTypeError
		| BoolPat b -> if (typecheck expr1 tenv)=BoolType then (typecheck expr2 tenv) else raise StaticTypeError
		| WildcardPat typ -> if typ=(typecheck expr1 tenv) then (typecheck expr2 tenv) else raise StaticTypeError
		(* check that expression 1 has type of typ; then we add that type into the type environment and typecheck expression 2 *)
		| VarPat (str,typ) -> if typ=(typecheck expr1 tenv) then (typecheck expr2 (Env.add_binding str typ tenv)) else raise StaticTypeError
		(* if we have a TuplePat, expression 2 must then be a Tuple of expression list *)
		| TuplePat l -> (match expr1 with
			(* check that lists have same length; then we typecheck expression 2 based on the type environment updated by TuplePat and Tuple *)
			Tuple l2 -> if (List.length l)=(List.length l2) then typecheck expr2 (listCheck l l2 tenv) else raise StaticTypeError
			| _ -> raise StaticTypeError)
		| _ -> raise StaticTypeError

and listCheck listPat listExpr tenv = (* updates type environment based on lists of TuplePat and Tuple  *)
	match listPat with
		[] -> tenv (* since lists are all the same length, if it becomes empty, we return the type environment *)
		| x::xs -> (match listExpr with
			[] -> tenv
			| y::ys -> (match x with
				(* for ints, bools, wildcards, check that the types match, then look at the rest of the list *)
				IntPat i -> if (typecheck y tenv)=IntType then listCheck xs ys tenv else raise StaticTypeError
				| BoolPat b -> if (typecheck y tenv)=BoolType then listCheck xs ys tenv else raise StaticTypeError
				| WildcardPat typ -> if typ=(typecheck y tenv) then listCheck xs ys tenv else raise StaticTypeError
				(* given a var, check if expression 1 has type typ; then check rest of list with updated environment from new binding *)
				| VarPat (str,typ) -> if typ=(typecheck y tenv) then (listCheck xs ys (Env.add_binding str typ tenv)) else raise StaticTypeError
				(* if we reach another TuplePat, do the same as before *)
				| TuplePat l -> (match y with
					(* feed the inner TuplePat, Tuple lists back into this function to make new type environment for the outer level TuplePat *)
					Tuple l2 -> if (List.length l)=(List.length l2) then listCheck xs ys (listCheck l l2 tenv) else raise StaticTypeError
					| _ -> raise StaticTypeError)
				| _ -> raise StaticTypeError))
		| _ -> raise StaticTypeError
		
and functionCheck pat expr tenv = 
	let eType = (typecheck expr tenv) in
		(match pat with
		IntPat i -> ArrowType(IntType, eType)
		| BoolPat b -> ArrowType(BoolType, eType)
		| WildcardPat typ -> ArrowType(typ, eType)
		| VarPat (str,typ) -> ArrowType(typ, typecheck expr (Env.add_binding str typ tenv))
		| TuplePat l -> ArrowType(TupleType(tuplePatToType l), eType)
		| _ -> raise StaticTypeError)

and tuplePatToType l = 
	match l with
		[] -> []
		| x::xs -> (match x with
			IntPat i -> IntType::tuplePatToType xs
			| BoolPat b -> BoolType::tuplePatToType xs
			| WildcardPat typ -> typ::tuplePatToType xs
			| VarPat (str,typ) -> typ::tuplePatToType xs
			| TuplePat l -> TupleType(tuplePatToType l)::tuplePatToType xs
			| _ -> raise StaticTypeError)
		| _ -> raise StaticTypeError