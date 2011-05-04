type 'a htree = Empty | Node of ('a * float) * 'a htree * 'a htree ;;

(* "czestosc" symbolu *)
let waga el =
	match el with
		| Node((a,b),_,_) -> b 
		| Empty -> 0.0 ;;
(* wstawianie elementu w odpowiednie miejsce na liscie *)
let rec insert el li =
	match li with
		| [] -> [el]
		| h::t -> if ( waga el ) < ( waga h ) then el::h::t
					else h::(insert el t) ;;
(* sortowanie przez wstawianie ( przy pierwszym uruchomieniu ) *)
let rec insert_sort li =
	match li with
		| [] -> []
		| h::t -> insert h ( insert_sort t ) ;;
(* budowanie drzewa huffmana, bierzemy 2 pierwsze elementy(poddrzewa)  z listy i wkladamy je w odpowiednie miejsce *)
let rec buduj lista =
	match lista with
		| [] -> []
		| Empty::_ -> []
		| (Node((_,h1),_,_) as h)::t -> 
			match t with
				| [] -> [h]
				| Empty::_ -> []
				| (Node((a,h2),_,_) as hh )::t2 -> 
						buduj (insert ( Node( (  '\000' , h1 +. h2 ) , h , hh ) ) t2 ) ;;


(* tworzenie drzewa, z listy asocjacyjnej *)
let rec zrob_drzewo lista =
	match lista with
		| [] -> []
		| h::t ->(Node((h),Empty,Empty))::(zrob_drzewo t);;
(*
buduj ( insert_sort [Node(('a',8.71),Empty,Empty);Node(('b',1.29),Empty,Empty);Node(('d',3.45),Empty,Empty);Node(('k',3.10),Empty,Empty);Node(('o',7.9),Empty,Empty);Node(('r',4.63),Empty,Empty)]);;
*)
(*

let drzefko = zrob_drzewo [('a',8.71);('b',1.29);('d',3.45);('k',3.10);('o',7.9);('r',4.63)] ;;
*)
(* tworzenie listy assocjacyjnej z kodem dla kazdego elementu *)
let codetable tree =
	let rec aux drzewko result  =
		match drzewko with
			| Empty -> []
			| Node((a,_),l,r) ->
					if ( l = Empty ) then [(a,result)] (* zawsze gdy l = Empty, to i r = Empty, wystarczy sprawdziæ tylko jedno, drzewo jest regularne *)
					else 
						( aux l (result@['0'])  ) @ ( aux r (result@['1'])  )
	in aux tree []  ;;

(* funkcja kodujaca liste elementow wg. konkretnego drzewa huffmana, zwracajaca liste kodow *)
let rec koduj li drzewo=
	match li with
		| [] -> []
		| h::t -> ( List.assoc h drzewo)@(koduj t drzewo) ;; 
		
(* chodzenie po danym drzewie wg schematu zapisanego na liscie *)
let rec decode li drz =
	let rec aux li' drz' = 
		match drz' with
			| Empty -> failwith "zle zbudowane drzewo"
			| Node( (a,b),l,r) ->
				match li' with
					| [] -> a::[] (* doklejenie ostatniego elementu *)
					| h::t -> (
						match l with (* jesli jestesmy na "dnie" doklejamy a, w innym przypadku przechodzimy w lewo/prawo ( wg schematu zapisanego w glowie listy ) *)
							| Empty -> a::(decode li' drz)
							| _ ->
								if ( h = '0' ) then aux t l
								else aux t r 
						)	
	in aux li drz ;;

	

let test1 = ['k';'o';'b';'r';'a'] ;;
let test2 = ['a';'b';'r';'a';'k';'a';'d';'a';'b';'r';'a'] ;;
let test_drzewo = (List.hd ( buduj ( insert_sort ( zrob_drzewo [('a',8.71);('b',1.29);('d',3.45);('k',3.10);('o',7.9);('r',4.63)] ) ) ) );;

let c = codetable test_drzewo ;;

koduj test1 c ;;
koduj test2 c;;

decode ( koduj test2 c ) test_drzewo ;;
