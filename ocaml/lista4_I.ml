exception Unbound_variable of string ;;
exception Not_tautology of string ;;

type expression = 
	Const of bool
	| Var of string
	| Neg of expression
	| Con of expression * expression
	| Alt of expression * expression
	| Imp of expression * expression ;;

let rec eval env exp =
	match exp with
		Const c -> c
		| Var v -> ( try List.assoc v env
					with Not_found -> raise(Unbound_variable v) ) 
		| Neg(a) -> not(eval env a)
		| Con(a,b) -> eval env a && eval env b
		| Alt(a,b) -> eval env a || eval env b
		| Imp(a,b) -> eval env (Neg a) || eval env b ;;
		
eval [("p",true);("q",false)]  (Con(Var "p",Neg(Var "q"))) ;;
eval [("p",true);("q",false)]  (Imp(Var "p",Var "q")) ;; 
eval [("p",true)] (Imp(Var "p",(Neg(Var "p"))));;
eval [("p",false)] (Imp(Var "p",(Neg(Var "p"))));;

(* making string from (string*bool) *)
let parse li =
	let rec skl acc li =
		match li with
			[] -> acc
			| (i,j)::t -> (
 				match j with
					false -> skl ("["^i^"]-> false "^acc) t
					| true -> skl ("["^i^"]-> true "^acc) t
				)
	in skl "" li ;;
	
let rec tautology_check exp env variables =
	match variables with
		[] ->
			if not (eval env exp) then	
				raise (Not_tautology (parse env)) 
			else true
		| h::t ->
			tautology_check exp ((h,true)::env) t;
			tautology_check exp ((h,false)::env) t ;;

			
tautology_check (Alt(Var "p",(Neg(Var "p")))) [] ["p"]  ;;
tautology_check (Imp(Var "p",(Neg(Var "q")))) [] ["p";"q"];;


(*** DYSJUNKCYJNA ****)
let dys_parse li =
	let rec skl acc li =
		match li with
			[] -> acc^" + "
			| (i,j)::t -> (
 				match j with
					false -> skl ("not("^i^") "^acc) t
					| true -> skl ("("^i^") "^acc) t
				)
	in skl "" li ;;
	
let rec dys exp env variables =
	match variables with
		[] ->
			if (eval env exp) then	
				print_string (dys_parse env)
			else ()
		| h::t ->
			dys exp ((h,true)::env) t;
			dys exp ((h,false)::env) t ;;



dys (Imp(Var "p",(Neg(Var "q")))) [] ["p";"q"];;

				