let ( search, append ) =
	let c = ref [] 
		in 
		  let 
			srch x =
				List.assoc x !c
			and app x =
				c:= !c @ [x]
		in ( srch , app ) ;;
		
let rec fib n =
	match n with
		| 0 -> 0 
		| 1 -> 1
		| n -> fib ( n-1 ) + fib ( n -2 ) ;;

fib 5 ;;

let fib_memo n =	
	try ( search n ) with Not_found ->
		let x = (append(n, (fib n ) ))
			in fib n
		 ;;

(*
fib_memo 30 ;;
fib_memo 32 ;;
fib_memo 32 ;; *)

	
fib_memo 30 ;;
fib_memo 30 ;;

