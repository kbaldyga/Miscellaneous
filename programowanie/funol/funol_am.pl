% Kamil Ba³dyga - 209184
:- module(funol_am, [run/2]).

lookup(M, X, N) :-
   member((X,N), M).

update([], X, N, [(X,N)]).
update([(X,_)|T], X, N, [(X,N)|T]) :-
   !.
update([A|T], X, N, [A|S]) :-
   update(T, X, N, S).

:- op(800, xfy, =>).
% Transitions for arithmetic expressions:

([constant(N) | C], R, M) => (C, [N|R], M).
([variable(X) | C], R, M) => ([lambda(Arg,Body)|C], R, M) :-
	lookup(M,X,lambda(Arg,Body)),!.
([variable(X) | C], R, M) => (C, [Val|R], M) :-
   lookup(M,X,Val).
([A | C], R, M) => ([A1, A2, Op | C], R, M) :-
   A =.. [Op, A1, A2],
   member(Op, [+, -, *, //, mod]).
([Op | C], [N2, N1 | R], M) => (C, [N | R], M) :-
   member(Op, [+, -, *, //, mod]),
   K =.. [Op, N1, N2],
   N is K.
([neg(N)|C], R, M) => ([N, neg|C], R, M).
([neg | C], [N|R], M) => (C, [N2|R], M) :-
	K =.. [*,N,(-1)],
	N2 is K.
%----------------
% Transitions for Lists
([cons(Head,Tail) | C], R, M) => ([ Tail, Head, cons | C], R, M).
([emptyList| C], R, M) => (C,[[]|R],M).
([cons , app | C], R, M) => (C,R,M).
([cons| C], [R1,L|R],M) => (	C, [ [R1|L] |R] ,M).
([cons|C],[R],M)=>(C,[R],M).
%--
([concat(First,Snd) | C], R, M) => ([ Snd, First, concat | C], R, M).
([concat | C], [R1,L|R], M) => (C, [New|R] ,M) :-
	append(R1,L,New).
%--
([head(List) | C], R, M) => ([List, head | C], R, M).
([head | C] , [ [H|_]| R], M) => (C, [H|R], M).
([tail(List) | C], R, M) => ([List, tail | C], R, M).
([tail | C], [ [_|T]|R], M) => (C,[T|R],M).
([null(List) | C], R, M) => ([List, null | C], R, M).
([null | C], [ List | R], M) => (C, [B|R], M) :-
	( List = [] -> B = true ; B = false ).
%---------------
% Transitions for Boolean expressions:

([B | C], R, M) => (C, [B | R], M) :-
   member(B, [true, false]).
([B | C], R, M) => ([A1, A2, Op | C], R, M) :-
   B =.. [Op, A1, A2],
   member(Op, [<, <=, >, >=, =, /=]).
([Op | C], [N2, N1 | R], M) => (C, [B | R], M) :-
   member(Op, [<, >, >=, =]),
   (call(Op, N1, N2) -> B = true; B = false).
([<= | C], [N2, N1 | R], M) => (C, [B | R], M) :-
   (N1 =< N2 -> B = true; B = false).
([/= | C], [N2, N1 | R], M) => (C, [B | R], M) :-
   (N1 =\= N2 -> B = true; B = false).
([not(B) | C], R, M) => ([B, not | C], R, M).
([not | C], [true | R], M) => (C, [false | R], M).
([not | C], [false | R], M) => (C, [true | R], M).
([B | C], R, M) => ([B1, B2, Op | C], R, M) :-
   B =.. [Op, B1, B2],
   member(Op, [or, and]).
([or | C], [B2, B1 | R], M) => (C, [B | R], M) :-
   (B1 = true ; B2 = true) -> B = true; B = false.
([and | C], [B2, B1 | R], M) => (C, [B | R], M) :-
   (B1 = true , B2 = true) -> B = true; B = false.

% Transitions for commands:
([C1 ';' C2 | C], R, M) => ([C1, C2 | C], R, M).
([if(B,C1,C2) | C], R, M) => ([B, if_else | C], [C1, C2 | R], M).
([if_else | C], [true, C1, _C2 | R], M) => ([C1 | C], R, M).
([if_else | C], [false, _C1, C2 | R], M) => ([C2 | C], R, M).

([def(Name,Body)|C], R, M) => ([Body,Name,def|C], R, M).
([ app(Name,Body) | C], R, M) => ([ Body, end, Name, app | C], R, M).
([ X, end , Name , app | C], R, M) => ([Name|C], [X|R], New) :- X \= head, X \= tail, update(M, Name, X, New).
([ end | C ] , R , M ) => (C,R,M).
([ app | C], R, M) => ( C, R, M ).

([ lambda(Arg, Body) , Name, def | C], R, M)
	=> (C,  R, New) :-
    update(M,Name,lambda(Arg,Body),New).
([ lambda(Arg,Body), app, Name, def |C], R, M) =>
	(C,R,New):-
		update(M,Name,lambda(Arg,Body),New).
([ lambda(Arg,Body) | C], [A | R], M) =>
	([Body, prevVar(Arg,F)| C], R, New) :-
    lookup(M,Arg,F),!,
    update(M,Arg,A,New).
([ lambda(Arg,Body) | C], [A | R], M) =>
	([Body, prevVar(Arg,[])| C], R, New) :-
    update(M,Arg,A,New).

([prevVar(K,V) | C],R,M) => (C,R,New) :-
    update(M,K,V,New).

:- op(800, xfy, *=>).

InitState *=> FinState :-
   InitState => NextState,
   NextState *=> FinState.
FinState *=> FinState.

debugger(InitState,Out) :-
   InitState => NextState,
   !,
   write(InitState),
   nl,
   debugger(NextState,Out).
debugger(FinState,FinState) :-
   write(FinState),
   nl.

:- use_module(funol).

run(Prog,Out) :-
   parse(Prog, P), debugger(([P], [], []),(_,Out,_)).

test_map(X) :-
  run("let map = \\ f -> \\ xs ->   if null xs then []  else f (head xs) : map f (tail xs);let h = \\ x -> x + 2;map h [1,2,3]",X).
test_cos(X) :-
  run("let cos = let cos2 = \\ y -> \\ d ->  if d = 0  then 1  else y * cos2 y (d - 1) ;  cos2 3 ; cos  3",X).
test_reverse(X) :-
  run("let reverse =  let aux = \\ xs -> if null xs then [] else (aux (tail xs))++[(head xs)];aux ; reverse [1,2,3]",X).
test_merge(X) :-
  run("let merge = \\ xs -> \\ ys -> if null xs then ys else if null ys then xs else if (head xs) < (head ys) then (head xs):(merge (tail xs) ys) else (head ys):(merge xs (tail ys)) ; merge [3,5,8,9,11,245] [4,15,62]",X).
