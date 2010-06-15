% Kamil Ba³dyga - 209184
:- module(funol, [parse/2]).
% set_prolog_flag(toplevel_print_options,[max_depth(120)]).
lexer(Tokens) -->
   white_space, comment,
   ( (
      "->",		      !, { Token = tokArrow }
      ;  "++",	  	!, { Token = tokConcat }
      ;	 ";",       !, { Token = tokColon }
      ;  "(",       !, { Token = tokLParen }
      ;  ")",       !, { Token = tokRParen }
	    ;  "[",	    	!, { Token = tokLSquare }
	    ;  "]",	    	!, { Token = tokRSquare }
      ;  "+",       !, { Token = tokPlus }
      ;  "-",       !, { Token = tokMinus }
      ;  "*",       !, { Token = tokTimes }
      ;  "<=",      !, { Token = tokLeq }
      ;  "<",       !, { Token = tokLt }
      ;  ">=",      !, { Token = tokGeq }
      ;  ">",       !, { Token = tokGt }
      ;  "\/=",     !, { Token = tokNeq }
      ;  "=",       !, { Token = tokEq }
	    ;  ",",	    	!, { Token = tokComma }
	    ;  ":",		    !, { Token = tokCons  }
	    ;  ("\\", white_space), ! ,
          letter(L),
          (identifier(L,Id), { Token = tokLambda(Id) },white_space)
      ; ("let", white_space) , ! ,
          letter(L),
          (identifier(L,Id), {Token = tokDef(Id)}, white_space)
      ;  digit(D),  !,
            number(D, N),
            { Token = tokNumber(N) }
      ;  letter(L), !, identifier(L, Id),
            {  member((Id, Token), [ (and, tokAnd),
                                     (div, tokDiv),
                                     (else, tokElse),
                                     (false, tokFalse),
                                     (if, tokIf),
                                     (mod, tokMod),
                                     (not, tokNot),
                                     (or, tokOr),
                                     (then, tokThen),
                                     (true, tokTrue),
									 (null, tokNull),
									 (head, tokHead),
									 (tail, tokTail)]),
               !
            ;  Token = tokVar(Id)
            }
      ;  [_],
            { Token = tokUnknown }
      ),
      !,
         { Tokens = [Token | TokList] },
      lexer(TokList)
     ;  [],
         { Tokens = [] }
   ).

white_space -->
   [Char], { code_type(Char, space) }, !, white_space.
white_space -->
   [].

comment -->
	"--", !, uncomment.
comment -->
	[].

uncomment -->
	"\n", !, white_space.
uncomment -->
	[_], uncomment.
digit(D) -->
   [D],
      { code_type(D, digit) }.

digits([D|T]) -->
   digit(D),
   !,
   digits(T).
digits([]) -->
   [].

number(D, N) -->
   digits(Ds),
      { number_chars(N, [D|Ds]) }.

letter(L) -->
   [L], { code_type(L, alpha) }.

alphanum([A|T]) -->
   [A], { code_type(A, alnum) }, !, alphanum(T).
alphanum([A|T]) -->
   [A], { A =:= "\'" }, !, alphanum(T).
alphanum([A|T]) -->
   [A], { A =:= "_" }, !, alphanum(T).
alphanum([]) -->
   [].

identifier(L, Id) -->
   alphanum(As),
      { atom_codes(Id, [L|As]) }.



program(Ast) -->
   instruction(Instr),
   { Ast = Instr }.


instruction(Instr) -->
    ( [tokIf],  bool_expr(Bool), [tokThen], program(ThenPart),
          [tokElse],  program(ElsePart),
               { Instr = if(Bool,ThenPart,ElsePart) }
     ; [tokDef(Var), tokEq], instruction(Body),[tokColon], instruction(Left),
		 	 { Instr = (def(Var,Body)';'Left) }
     ; [tokLambda(Var),tokArrow], instruction(Body),
		   { Instr = lambda(Var,Body) }
     ; list_expr(Expr), {Instr = Expr}
     ; bool_expr(Expr), {Instr = Expr}
   ).


list_expr(Expr) -->
	next_expr(Next), list_expr(Next,Expr).
list_expr(Acc,Expr) -->
	[tokCons], instruction(Next),
		{ Acc1 =.. [cons,Acc,Next] }, next_expr(Acc1,Expr).
list_expr(Acc,Acc) -->
	[].

next_expr(Expr) -->
	left_expr(Left), next_expr(Left,Expr).
next_expr(Acc,Expr) -->
	[tokConcat], instruction(Left),
		{ Acc1 =.. [concat,Acc,Left] }, left_expr(Acc1,Expr).
next_expr(Acc,Acc) -->
	[].

left_expr(Expr) -->
	arith_expr(Expr).
left_expr(Acc,Acc) -->
	[].

arith_expr(Expr) -->
   summand(Summand), arith_expr(Summand, Expr).
arith_expr(Acc, Expr) -->
   additive_op(Op),  summand(Summand),
      { Acc1 =.. [Op,Acc,Summand] }, arith_expr(Acc1, Expr).
arith_expr(Acc, Acc) -->
   [].

summand(Expr) -->
   app_expr(Factor), summand(Factor, Expr).

summand(Acc, Expr) -->
   multiplicative_op(Op),  app_expr(Factor),
      { Acc1 =.. [Op, Acc, Factor] }, summand(Acc1, Expr).
summand(Acc, Acc) -->
   [].

factor(Expr) -->
   (  [tokLParen],  instruction(Expr), [tokRParen]
    ; [tokNumber(N)],  { Expr = constant(N) }
    ; [tokVar(Var)], { Expr = variable(Var) }
    ; [tokLSquare],[tokRSquare], { Expr = emptyList }
    ; [tokLSquare], cont_expr(Ciag), [tokRSquare], {Expr = Ciag}
    ; [tokHead], list_expr(Lexpr), {Expr = head(Lexpr)}
    ; [tokTail], list_expr(Lexpr), {Expr = tail(Lexpr)}
   ).

factor(Acc,Acc) --> [].
app_expr(Expr) -->
	factor(Expr2), app_expr(Expr2,Expr).
app_expr(Acc,Expr) -->
	  factor(AE),
		{ Acc1 =.. [app,Acc,AE] }, app_expr(Acc1,Expr).
app_expr(Acc,Acc) -->
	[].
cont_expr(Expr) -->
	list_expr(Expr2),cont_expr(Expr2,Expr).

cont_expr(Acc,Expr) -->
	[tokComma], cont_expr(Lexp),
		{ Acc1 =.. [cons,Acc,Lexp] }, list_expr(Acc1,Expr).
cont_expr(Acc,Out) -->
	{ Out = cons(Acc,emptyList) }.

bool_expr(Bool) -->
   disjunct(Disjunct), bool_expr(Disjunct, Bool).

bool_expr(Acc, Bool) -->
   [tokOr],  disjunct(Disjunct),
      { Acc1 =.. [or, Acc, Disjunct] }, bool_expr(Acc1, Bool).
bool_expr(Acc, Acc) -->
   [].

disjunct(Disjunct) -->
   conjunct(Conjunct), disjunct(Conjunct, Disjunct).

disjunct(Acc, Disjunct) -->
   [tokAnd],  conjunct(Conjunct),
      { Acc1 =.. [and, Acc, Conjunct] }, disjunct(Acc1, Disjunct).
disjunct(Acc, Acc) -->
   [].

conjunct(Conjunct) -->
   (  [tokLParen],  bool_expr(Conjunct), [tokRParen]
   ;  [tokNot],  conjunct(NotConjunct), {Conjunct = not(NotConjunct)}
   ;  [tokMinus], factor(Expr), { Conjunct = neg(Expr)}
   ;  [tokTrue],  { Conjunct = true }
   ;  [tokFalse], { Conjunct = false }
   ;  [tokNull], instruction(Lexpr), {Conjunct = null(Lexpr)}
   ;  arith_expr(LExpr), rel_op(Op), arith_expr(RExpr),
      { Conjunct =.. [Op, LExpr, RExpr] }
   ).

additive_op(+) -->
   [tokPlus].
additive_op(-) -->
   [tokMinus].

multiplicative_op( * ) -->
   [tokTimes].
multiplicative_op(//) -->
   [tokDiv].
multiplicative_op(mod) -->
   [tokMod].


rel_op(/=) -->
   [tokNeq].
rel_op(=) -->
   [tokEq].
rel_op(<) -->
   [tokLt].
rel_op(<=) -->
   [tokLeq].
rel_op(>) -->
   [tokGt].
rel_op(>=) -->
   [tokGeq].

parse(CharCodeList, Absynt) :-
   phrase(lexer(TokList), CharCodeList),
   phrase(program(Absynt), TokList).