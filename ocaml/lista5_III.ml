type 'a llist = LNil | LCons of 'a * (unit -> 'a llist ) ;;

let rec lfilter pred = function
	| LNil -> LNil
	| LCons (x,xf) -> if pred x 
							then LCons(x, function () -> lfilter pred (xf()) )
						else lfilter pred (xf()) ;;
						
let rec ltakeWithTail = function
	| (0,xq) -> ([], xq)
	| (n,LNil ) -> ([], LNil )
	| (n,LCons(x,xf)) ->
		let (l,tail) = ltakeWithTail(n-1,xf())
			in (x::l,tail) ;;

let breadthFirst next x =
	let rec bfs = function 
		| [] -> LNil
		| (h::t) -> LCons ( h , function () -> bfs ( t @ (next h) ) )
	in bfs [x] ;;
	
let isQueenSafe oldqs newq =
	let rec nodiag = function
		| (i,[]) -> true
		| (i, q::qt) -> abs(newq-q) <> i && nodiag(i+1,qt)
	in not (List.mem newq oldqs) && nodiag(1,oldqs) ;;
	
let rec fromTo a b =
	if a > b then []
	else a::(fromTo (a+1) b) ;;

let nextQueen n qs =
	List.map ( function h -> h::qs)
			( List.filter (isQueenSafe qs) (fromTo 1 n) ) ;;
			
let isSolution n qs = List.length qs = n ;;

let depthQueen n = lfilter ( isSolution n ) (breadthFirst (nextQueen n) [] ) ;;

let (dq,t) = ltakeWithTail (92, depthQueen 5);;
