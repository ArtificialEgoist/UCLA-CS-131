type token =
  | INT of (int)
  | BOOL of (bool)
  | VAR of (string)
  | TYPE_UNIT
  | TYPE_INT
  | TYPE_BOOL
  | FUNCTION
  | PIPE
  | WILDCARD
  | FN_ARROW
  | IF
  | THEN
  | ELSE
  | LET
  | EQ
  | IN
  | MATCH
  | WITH
  | LPAREN
  | RPAREN
  | PLUS
  | STAR
  | COMMA
  | COLON
  | EOE

open Parsing;;
# 2 "parser.mly"
exception ConstTypeParseError
exception TypeArrowExpectedButFnArrowFoundParseError

let print_productions = false
let print p = if print_productions then print_string (p^"\n") else ()
# 36 "parser.ml"
let yytransl_const = [|
  260 (* TYPE_UNIT *);
  261 (* TYPE_INT *);
  262 (* TYPE_BOOL *);
  263 (* FUNCTION *);
  264 (* PIPE *);
  265 (* WILDCARD *);
  266 (* FN_ARROW *);
  267 (* IF *);
  268 (* THEN *);
  269 (* ELSE *);
  270 (* LET *);
  271 (* EQ *);
  272 (* IN *);
  273 (* MATCH *);
  274 (* WITH *);
  275 (* LPAREN *);
  276 (* RPAREN *);
  277 (* PLUS *);
  278 (* STAR *);
  279 (* COMMA *);
  280 (* COLON *);
  281 (* EOE *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* BOOL *);
  259 (* VAR *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\003\000\003\000\
\006\000\006\000\007\000\007\000\007\000\007\000\007\000\008\000\
\008\000\005\000\005\000\010\000\010\000\004\000\004\000\004\000\
\004\000\004\000\004\000\012\000\013\000\013\000\009\000\014\000\
\014\000\011\000\011\000\011\000\011\000\011\000\011\000\015\000\
\016\000\016\000\000\000"

let yylen = "\002\000\
\002\000\001\000\004\000\004\000\006\000\006\000\001\000\003\000\
\001\000\002\000\001\000\002\000\001\000\003\000\003\000\001\000\
\001\000\003\000\004\000\004\000\005\000\001\000\005\000\005\000\
\002\000\003\000\003\000\003\000\003\000\001\000\003\000\003\000\
\001\000\001\000\001\000\001\000\003\000\003\000\003\000\003\000\
\003\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\016\000\017\000\013\000\000\000\000\000\000\000\
\000\000\000\000\043\000\000\000\002\000\000\000\009\000\011\000\
\000\000\000\000\022\000\000\000\000\000\000\000\012\000\000\000\
\000\000\001\000\000\000\010\000\000\000\000\000\025\000\000\000\
\000\000\000\000\000\000\000\000\000\000\014\000\000\000\015\000\
\008\000\000\000\000\000\026\000\000\000\027\000\003\000\000\000\
\000\000\000\000\004\000\000\000\031\000\036\000\034\000\035\000\
\000\000\000\000\000\000\000\000\028\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\024\000\023\000\000\000\005\000\
\006\000\000\000\032\000\038\000\000\000\039\000\000\000\029\000\
\000\000\019\000\000\000\040\000\000\000\000\000\000\000\041\000\
\000\000\021\000"

let yydgoto = "\002\000\
\011\000\052\000\013\000\060\000\051\000\014\000\015\000\016\000\
\025\000\082\000\083\000\033\000\061\000\053\000\067\000\084\000"

let yysindex = "\006\000\
\066\255\000\000\000\000\000\000\000\000\009\255\066\255\009\255\
\066\255\035\255\000\000\251\254\000\000\020\255\000\000\000\000\
\055\255\019\255\000\000\039\255\044\255\047\255\000\000\025\255\
\058\255\000\000\066\255\000\000\060\255\065\255\000\000\027\255\
\059\255\066\255\066\255\066\255\009\255\000\000\066\255\000\000\
\000\000\012\255\012\255\000\000\009\255\000\000\000\000\069\255\
\074\255\083\255\000\000\071\255\000\000\000\000\000\000\000\000\
\012\255\033\255\061\255\073\255\000\000\066\255\066\255\066\255\
\066\255\050\255\078\255\012\255\000\000\000\000\009\255\000\000\
\000\000\092\255\000\000\000\000\012\255\000\000\091\255\000\000\
\009\255\000\000\248\254\000\000\097\255\012\255\066\255\000\000\
\092\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\079\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\088\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\090\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\093\255\000\000\000\000\000\000\000\000\005\255\000\000\
\000\000\000\000\094\255\000\000\000\000\000\000\000\000\000\000\
\107\255\000\000"

let yygindex = "\000\000\
\000\000\255\255\000\000\007\000\000\000\000\000\089\000\251\255\
\000\000\023\000\218\255\000\000\044\000\052\000\000\000\035\000"

let yytablesize = 132
let yytable = "\012\000\
\019\000\068\000\019\000\058\000\059\000\020\000\001\000\022\000\
\024\000\003\000\004\000\019\000\018\000\086\000\021\000\054\000\
\055\000\056\000\066\000\026\000\003\000\004\000\005\000\032\000\
\037\000\041\000\037\000\017\000\034\000\079\000\057\000\019\000\
\047\000\048\000\049\000\003\000\004\000\005\000\010\000\019\000\
\027\000\006\000\068\000\050\000\038\000\007\000\044\000\039\000\
\008\000\045\000\035\000\009\000\069\000\010\000\023\000\003\000\
\004\000\029\000\036\000\068\000\072\000\073\000\074\000\030\000\
\037\000\019\000\003\000\004\000\005\000\076\000\068\000\077\000\
\006\000\017\000\031\000\019\000\007\000\040\000\046\000\008\000\
\070\000\062\000\009\000\042\000\010\000\089\000\007\000\085\000\
\043\000\063\000\007\000\007\000\064\000\065\000\007\000\071\000\
\007\000\078\000\007\000\081\000\068\000\007\000\028\000\007\000\
\018\000\018\000\087\000\033\000\018\000\030\000\018\000\090\000\
\018\000\042\000\080\000\018\000\075\000\018\000\020\000\020\000\
\088\000\000\000\020\000\000\000\020\000\000\000\020\000\000\000\
\000\000\020\000\000\000\020\000"

let yycheck = "\001\000\
\006\000\010\001\008\000\042\000\043\000\007\000\001\000\009\000\
\010\000\001\001\002\001\017\000\006\000\022\001\008\000\004\001\
\005\001\006\001\057\000\025\001\001\001\002\001\003\001\017\000\
\020\001\027\000\022\001\019\001\010\001\068\000\019\001\037\000\
\034\000\035\000\036\000\001\001\002\001\003\001\019\001\045\000\
\021\001\007\001\010\001\037\000\020\001\011\001\020\001\023\001\
\014\001\023\001\012\001\017\001\020\001\019\001\020\001\001\001\
\002\001\003\001\015\001\010\001\062\000\063\000\064\000\009\001\
\018\001\071\000\001\001\002\001\003\001\020\001\010\001\022\001\
\007\001\019\001\020\001\081\000\011\001\020\001\020\001\014\001\
\020\001\013\001\017\001\024\001\019\001\087\000\008\001\081\000\
\024\001\016\001\012\001\013\001\010\001\023\001\016\001\023\001\
\018\001\020\001\020\001\008\001\010\001\023\001\014\000\025\001\
\012\001\013\001\010\001\020\001\016\001\020\001\018\001\089\000\
\020\001\020\001\071\000\023\001\065\000\025\001\012\001\013\001\
\086\000\255\255\016\001\255\255\018\001\255\255\020\001\255\255\
\255\255\023\001\255\255\025\001"

let yynames_const = "\
  TYPE_UNIT\000\
  TYPE_INT\000\
  TYPE_BOOL\000\
  FUNCTION\000\
  PIPE\000\
  WILDCARD\000\
  FN_ARROW\000\
  IF\000\
  THEN\000\
  ELSE\000\
  LET\000\
  EQ\000\
  IN\000\
  MATCH\000\
  WITH\000\
  LPAREN\000\
  RPAREN\000\
  PLUS\000\
  STAR\000\
  COMMA\000\
  COLON\000\
  EOE\000\
  "

let yynames_block = "\
  INT\000\
  BOOL\000\
  VAR\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'exp) in
    Obj.repr(
# 42 "parser.mly"
            ( print ";;"; _1 )
# 211 "parser.ml"
               : moexpr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'plusexp) in
    Obj.repr(
# 45 "parser.mly"
            ( _1 )
# 218 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 46 "parser.mly"
                                  ( print "e -> function p -> e"; Function(_2,_4) )
# 226 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'exp) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'fn_patterns) in
    Obj.repr(
# 47 "parser.mly"
                               ( print "e -> match e with ps"; Match(_2,_4) )
# 234 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'exp) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'exp) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 48 "parser.mly"
                             ( print "e -> if e then e else e"; If(_2,_4,_6) )
# 243 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'exp) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 49 "parser.mly"
                              ( print "e -> let p = e in e"; Let((_2,_4), _6) )
# 252 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'appexp) in
    Obj.repr(
# 53 "parser.mly"
           ( print "pe -> ae"; _1 )
# 259 "parser.ml"
               : 'plusexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'appexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 57 "parser.mly"
                    ( print "pe -> ae+e"; Plus(_1,_3) )
# 267 "parser.ml"
               : 'plusexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'baseexp) in
    Obj.repr(
# 61 "parser.mly"
            ( print "ae -> be"; _1 )
# 274 "parser.ml"
               : 'appexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'appexp) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'baseexp) in
    Obj.repr(
# 62 "parser.mly"
                   ( print "ae -> ae ae"; FunctionCall(_1,_2) )
# 282 "parser.ml"
               : 'appexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'const) in
    Obj.repr(
# 65 "parser.mly"
        ( print "be -> c"; _1 )
# 289 "parser.ml"
               : 'baseexp))
; (fun __caml_parser_env ->
    Obj.repr(
# 66 "parser.mly"
                  ( print "e -> ()"; Tuple([]) )
# 295 "parser.ml"
               : 'baseexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 67 "parser.mly"
          ( print ("be -> var "^_1); Var(_1) )
# 302 "parser.ml"
               : 'baseexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'exp) in
    Obj.repr(
# 68 "parser.mly"
                      ( print "be -> (e)"; _2 )
# 309 "parser.ml"
               : 'baseexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'exp_tuple) in
    Obj.repr(
# 69 "parser.mly"
                            ( print "e -> (et)"; Tuple(_2) )
# 316 "parser.ml"
               : 'baseexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 73 "parser.mly"
         ( print ("c -> int "^(string_of_int _1)); IntConst(_1) )
# 323 "parser.ml"
               : 'const))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : bool) in
    Obj.repr(
# 74 "parser.mly"
         ( print ("c -> bool "^(string_of_bool _1)); BoolConst(_1) )
# 330 "parser.ml"
               : 'const))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 77 "parser.mly"
                         ( print "fp -> p -> e"; [(_1,_3)] )
# 338 "parser.ml"
               : 'fn_patterns))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'exp) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'fn_patternsAux) in
    Obj.repr(
# 78 "parser.mly"
                                        ( print "fp -> e fpA"; (_1,_3) :: _4 )
# 347 "parser.ml"
               : 'fn_patterns))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 81 "parser.mly"
                              ( print "fpA -> | p -> e"; [(_2,_4)] )
# 355 "parser.ml"
               : 'fn_patternsAux))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'pattern) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'exp) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'fn_patternsAux) in
    Obj.repr(
# 82 "parser.mly"
                                             ( print "fpA -> | p -> e fpA"; (_2,_4) :: _5 )
# 364 "parser.ml"
               : 'fn_patternsAux))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'const) in
    Obj.repr(
# 85 "parser.mly"
          ( print "p -> c";
				match _1 with
					 IntConst(i)  -> IntPat(i)
				  | BoolConst(b) -> BoolPat(b)
				  | _ -> raise ConstTypeParseError )
# 375 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    Obj.repr(
# 90 "parser.mly"
                                     ( print "p -> w:t"; WildcardPat(_4) )
# 382 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    Obj.repr(
# 91 "parser.mly"
                                ( print ("p -> var "^_2^":t"); VarPat(_2,_4) )
# 390 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    Obj.repr(
# 92 "parser.mly"
                  ( print "p -> ()"; TuplePat([]) )
# 396 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'pattern) in
    Obj.repr(
# 93 "parser.mly"
                          ( print "p -> (p)"; _2 )
# 403 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'pattern_tuple) in
    Obj.repr(
# 94 "parser.mly"
                                ( print "p -> (pt)"; TuplePat(_2) )
# 410 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'pattern_tupleAux) in
    Obj.repr(
# 97 "parser.mly"
                                   ( print "pt -> pt, ptA"; _1 :: _3 )
# 418 "parser.ml"
               : 'pattern_tuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'pattern_tupleAux) in
    Obj.repr(
# 100 "parser.mly"
                                   ( print "ptA -> p, ptA"; _1 :: _3 )
# 426 "parser.ml"
               : 'pattern_tupleAux))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'pattern) in
    Obj.repr(
# 101 "parser.mly"
            ( print "ptA -> p"; [_1] )
# 433 "parser.ml"
               : 'pattern_tupleAux))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'exp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'exp_tupleAux) in
    Obj.repr(
# 104 "parser.mly"
                           ( print "et -> et, etA"; _1 :: _3 )
# 441 "parser.ml"
               : 'exp_tuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'exp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'exp_tupleAux) in
    Obj.repr(
# 107 "parser.mly"
                           ( print "etA -> e, etA"; _1 :: _3 )
# 449 "parser.ml"
               : 'exp_tupleAux))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 108 "parser.mly"
        ( print "eAt -> e"; [_1] )
# 456 "parser.ml"
               : 'exp_tupleAux))
; (fun __caml_parser_env ->
    Obj.repr(
# 111 "parser.mly"
             ( print "t -> ti"; IntType )
# 462 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 112 "parser.mly"
              ( print "t -> tb"; BoolType )
# 468 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 113 "parser.mly"
              ( print "t -> tu"; UnitType )
# 474 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'typ) in
    Obj.repr(
# 114 "parser.mly"
                     ( print "t -> t=>t"; ArrowType(_1,_3) )
# 482 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    Obj.repr(
# 115 "parser.mly"
                      ( print "t -> (t)"; _2 )
# 489 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'typ_tuple) in
    Obj.repr(
# 116 "parser.mly"
                            ( print "t -> (tt)"; TupleType(_2) )
# 496 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'typ_tupleAux) in
    Obj.repr(
# 119 "parser.mly"
                          ( print "tt -> tt * ttA"; _1 :: _3 )
# 504 "parser.ml"
               : 'typ_tuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'typ_tupleAux) in
    Obj.repr(
# 122 "parser.mly"
                          ( print "ttA -> tt * ttA"; _1 :: _3 )
# 512 "parser.ml"
               : 'typ_tupleAux))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'typ) in
    Obj.repr(
# 123 "parser.mly"
        ( print "ttA -> t"; [_1] )
# 519 "parser.ml"
               : 'typ_tupleAux))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : moexpr)
