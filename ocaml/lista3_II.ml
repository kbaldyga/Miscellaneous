(*****************************)
let czy_poprawna lista =
		let rec aux dl li =
			match li with
				[] -> true
				| h::t ->
					if dl != List.length h then false
					else aux dl t
		in aux (List.length lista) lista ;;
		
czy_poprawna [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] ;;

let czy_poprawna' lista =
	let dl = List.length lista
	in
		let rec aux li =
			match li with
				[] -> true
				| h::t ->
					if dl != List.length h then false (* porownujemy dlugosc calej listy, z dlugosciami kolejnych podlist, jesli cos sie nie zgadza przerywamy i zwracamy false *)
					else aux t
		in aux lista ;;
		
czy_poprawna' [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] ;;
(*****************************)
let kolumna n macierz =
	let rec aux acc n macierz =
		match macierz with 
			[] -> (List.rev acc)
			| h::t ->
				aux ((List.nth h n)::acc) n t	(* n-ty element listy doklejany do akumulatora *)
		in aux [] (n-1) macierz ;;
		
kolumna 1 [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] ;;
kolumna 2 [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] ;;
kolumna 3 [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] ;;
(*****************************)
let transpozycja macierz =	
	let rec aux acc n =
		match n with
			0 -> acc
			| _ -> aux ((kolumna n macierz)::acc) (n-1)
	in aux [] (List.length macierz);;
transpozycja [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] ;;
(*****************************)
let zip li1 li2 =
	let rec aux acc li1' li2' =
		match (li1',li2') with
			([],[]) -> (List.rev acc)
			| (h1::t1,h2::t2) -> aux ((h1,h2)::acc) t1 t2
			| (_,[]) -> failwith "rozne dlugosci"
			| ([],_) -> failwith "rozne dlugosci"
	in aux [] li1 li2 ;;
	
zip [1.;2.;3.] ["a";"b";"c"] ;;
(*****************************)
let zipf f li1 li2  =
	let rec aux acc li f =
		match li with
			[] -> (List.rev acc)
			| h::t -> aux ( (f (fst h) (snd h))::acc ) t f
	in aux [] (zip li1 li2) f ;;
zipf ( +. ) [1.;2.;3.] [4.;5.;6.];;
(*****************************)
let mult_vec wektor macierz =
	let rec aux acc n =
		match n with 
			0 -> acc
			| _ ->
				aux ( 
					(List.fold_right (+.) 
						(zipf ( *. ) (kolumna n macierz) wektor ) 0. )
							::acc)  (n-1)
		in aux [] (List.length macierz) ;;
		
mult_vec [1.;2.] [[2.;0.];[4.;5.]];;
(*******************http://wims.unice.fr/wims/wims.cgi**********)
let mnoz m1 m2 =
	let rec aux acc pierwsza =
		match pierwsza with
			[] -> (List.rev acc)
			| h::t ->
				aux ((mult_vec h m2)::acc) t
	in aux [] m1 ;;
mnoz [[2.;0.];[4.;5.]] [[2.;0.];[4.;5.]] ;;
mnoz [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]];;