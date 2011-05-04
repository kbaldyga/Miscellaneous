(************** LAZY Z WYK£ADU *************)
type 'a llist = LNil | LCons of 'a * (unit -> 'a llist ) ;;

let lhd = function 
	LNil -> failwith "lhd"
	| LCons (x,_) -> x ;;

let tlt = function
	LNil -> failwith "ltl"
	| LCons (_,xf) -> xf () ;;
	
let rec lfrom k = LCons (k, function () -> lfrom (k+1)) ;;

let rec ltake = function 
	(0,xq) -> []
	| (n,LNil) -> []
	| (n,LCons(x,xf)) -> x::ltake(n-1,xf()) ;;
	
let pii =	
	let rec pi k n p= LCons ( k, function () -> pi (
							 (k +. 
								( 	if ( p mod 2 = 0 ) then
										(-1.) *.  (1. /. n )
									else ( 1. /. n)
								)
							 ) 
							) 
							(n +. 2. ) (p+1)) 
	in pi 1. 3. 0
	;;

let rec drugi f  = function 
		| LNil -> failwith " "
		| LCons(x1, xf ) ->  
				match xf() with
					| LNil -> failwith " "
					| LCons(x2,xff) -> 
						match xff() with
							| LNil -> failwith " "
							| LCons(x3,xfff) -> 
								LCons((f x1 x2 x3), function () -> (drugi f (xf ()) ) )  ;;


(List.hd ( List.rev (
		ltake ( 100,  pii ) )))*. 4.;;	


let euler =
	fun x y z -> z -. ( (y -. z ) *. ( y -. z ) /. ( z -. 2. *. y +. z ) ) ;;
	
List.hd ( List.rev ( ltake(100, drugi euler (pii))) ) *. 4. ;;

(************** LAZY_T**********************)
type 'a llist = LNil | LCons of 'a * 'a llist lazy_t ;;

let lhd = function
	| LNil -> failwith "lhd"
	| LCons (x,_) ->  x ;;

let tlt = function
	| LNil -> failwith "ltl"
	| LCons (_,xf) -> xf;;
	
let rec lfrom k = LCons (k, lazy (lfrom (k+1) )) ;;

let rec ltake n = function
	| LCons (a, ll) when n > 0 -> a::(ltake (n-1) (Lazy.force ll))
	| _ -> [] ;;
 
let pii  = 
	let rec pi k n p= LCons ( k, lazy (  pi (
							 (k +. 
								( 	if ( p mod 2 = 0 ) then
										(-1.) *.  (1. /. n )
									else ( 1. /. n)
								)
							 ) 
							)   
							(n +. 2. ) (p+1)) ) 
	in pi 1. 3. 0
	;;
	
let euler =
	fun x y z -> z -. ( (y -. z ) *. ( y -. z ) /. ( z -. 2. *. y +. z ) ) ;;	
	
let rec drugi f  = function 
		| LNil -> failwith " "
		| LCons(x1,  xf) ->  
				match (Lazy.force xf) with
					| LNil -> failwith " "
					| LCons(x2, xff) -> 
						match (Lazy.force xff) with
							| LNil -> failwith " "
							| LCons(x3,xfff) -> 
								LCons((f x1 x2 x3), lazy (drugi f (Lazy.force xf ) ) )  ;;	
	
	
List.hd ( List.rev (ltake 100 pii) ) *. 4.  ;;

List.hd ( List.rev ( ltake 100 ( drugi euler (pii))) ) *. 4. ;;
