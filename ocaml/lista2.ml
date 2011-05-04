(* ZADANIE 1 *)
(*let rec pdl li =	
	if li = [] then [ [] ]
	else (pdl (List.tl li)) @
		(List.map (List.append (List.hd li)) (pdl (List.tl li)) );;

let rec unf li = 
	match li with
	[] -> []
	| h::t -> [h]::(unf t) ;;

let dzialaj lista =
	pdl ( unf lista ) ;;
	
dzialaj [1;2;3;4] ;;
*)
let rec podciag lista = 
	match lista with 
		[] -> [ [] ]
		| h::t -> let podc = podciag t
	in 
		podc @ (List.map ( function h' -> h::h' ) (podc)) ;;

podciag [1;2;3;4];;

(* ZADANIE 2*)
let rec rekurencja n =
	match n with
	 0 -> 1
	| 1-> 2
	| _-> 2*(rekurencja (n-2))-(rekurencja (n-1))+1;;
rekurencja 25 ;;	
	
let tail_rec n = 
	let rec aux n wynik nastepny =
		if n = 0 then wynik
		else ( aux (n-1) nastepny (2*wynik-nastepny+1))
	in aux n 1 2 ;;

tail_rec 25 ;;

(* ZADANIE 3 - reverse ogonowo*)
let f = fun i -> 2*i ;;
let reverse lista f = 
	let rec aux li acc f =
		match li with
			[] -> acc
			| (h::t) -> aux t ((f h)::acc) f
		in aux lista [] f;;
			
reverse [1;2;3;4;5] f;;
(*** rekurencyjnie ***)
let f = fun i -> 2*i ;;
let rec reverse lista fu= 
	match lista with
		[] -> []
		| (h::t) -> (reverse t fu)@[(fu h)] ;;

reverse [1;2;3;4;5] f;;

(*
let rec merge cmp (a,b) =
	match (a,b) with
		(_,[]) -> a
		| ([],_) -> b
		| (h1::t1, h2::t2) ->
			if ( cmp h1 h2 ) then h1::(merge cmp (t1,b))
			else h2::(merge cmp (a,t2)) ;;
			
merge (<=) ([4;5;6],[1;2;3]);;
*)
(* merge tail-recursive *)
let merge' cmp (a,b) =
	let rec aux cmp acc (a,b) =
		match (a,b) with 
			(_,[]) -> (List.rev acc)@a
			| ([],_) -> (List.rev acc)@b
			| (h1::t1, h2::t2) ->
				if ( cmp h1 h2 ) then aux cmp (h1::acc) (t1,b)
				else aux cmp (h2::acc) (a,t2)
		in aux cmp [] (a,b) ;;
		
merge' (<=) ([4;5;6],[1;2;3]);;

(* dzielenie ciagu na pó³ *)
 let rec odd li =
	match li with
		[] -> []
		| x::xs -> even xs
		and
			even li =
				match li with
					[] -> []
					| x::xs -> x::odd xs ;;
odd [1;2;3;4;5] ;;
even [1;2;3;4;5];;

let dziel lista =
	let rec aux li acc1 acc2 =
	match li with
		[] -> (List.rev acc1, List.rev acc2)
		| (x::ys) -> aux ys (x::acc2) acc1
	in aux lista [] [];;
	
dziel [1;2;3;4;5];;	

let rec mergesort li =
	match li with
		[] -> []
		| [x] -> [x]
		| _ -> merge' (<=) (( mergesort (fst(dziel li ) )), (mergesort (snd(dziel li )) ) );;
		
mergesort [53;23;56;76;8;4;34;1;12;54;7;8;975;645;32;21;2;25;658;2];;

(* permutacja *)
let rec wrzuc el = function
	[] -> [ [el] ]
	| h::t -> (el::h::t)::
		(List.map (fun x -> h::x) (wrzuc el t)) ;;
let rec permutacja li =
	match li with
		[] -> [ [] ]
		| h::t -> List.flatten ( List.map ( wrzuc h) (permutacja t)) ;;
		
permutacja [1;2];;