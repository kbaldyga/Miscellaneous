(* ZADANIE 1 *)
let horner (x:float) li =
	let rec aux acc (x:float) li =
		match li with 
			[] -> acc
			| h::t ->
				aux ((x *. acc +. h)) x t 
		in aux 0. x li;;
 
horner 2.0 [4.;1.;7.;1.];;
 
let horner' (x:float) li =
	List.fold_left ( fun acc -> (+.) (x *. acc ) ) 0. li;; 
 
horner' 2. [4.;1.;7.;1.];;
horner' 3. [2.;0.;1.;4.];;
 
(* ZADANIE 2 *)
(*
let horner2 (x:float) li =
	let rec aux acc (x:float) li =
		match li with 
			[] -> acc
			| h::t ->
				aux ((x *. acc +. h)) x t 
		in aux 0. x (List.rev li);;
 
horner2 2.0 [1.;7.;1.;4.];;
horner2 3. [4.;1.;0.;2.];;
*)

let rec wielomian li x =
    match lista with
	    h::[]-> h      
		| h::t->x*.(wielomian t x )+. h ;;   

		
let horner2' (x:float) li =
	List.fold_right ( fun acc v -> acc +. x *. v ) li 0. ;; 
 
horner2' 2. [1.;7.;1.;4.];;
horner2' 3. [4.;1.;0.;2.];;
 
(* ZADANIE 3 *)
let pochodna li =
	let rec aux acc wsp li' =
		match li' with 
			[] -> List.rev acc
			| h::t -> (aux ((wsp*h)::acc) (wsp+1) t)
	in aux [] 1 (List.tl li) ;;
 
pochodna [1;0;-1;2] ;;