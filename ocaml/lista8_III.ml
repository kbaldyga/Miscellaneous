type database = Student of string * string * string * string ;;

let fileIN = "studenci.txt";;
let fileOUT = "wynik.txt";;

(* funkcja pomocnicza do wyciecia kilku poczatkowych znakow *)
let suffix s i = try String.sub s i ((String.length s)-i) 
                  with Invalid_argument("String.sub") -> "" ;;
				  
(* funkcja rozdzielajaca string na tablice stringow wzgledem znaku podanego jako argument (c) *)
let split c s = 
	let rec split_from n = 
		try  let p = String.index_from s n c 
			in (String.sub s n (p-n)) :: (split_from (p+1)) 
		with Not_found -> [ suffix s n ] 
	in 
		if s="" then [] else split_from 0 ;;
		
(* funkcja wczytujaca dane z pliku, rozdzelajaca wzgledem znaku dwukropka i zapisujaca  liste list elementow danych dla kazdego studenta *)
let get () =
	let ic = open_in fileIN 
	in
	let rec mklist acc =
		try
			mklist (split ':' (input_line ic)::acc) with End_of_file ->
				List.rev acc
		in mklist [] ;;

(* sortowanie wzgledem liczby punktow, oraz nazwiska ( punkty co = 3, nazwisko co = 1 ) *)
let sort l co =
	let rec insert el li =
		match li with
			| [] -> [el]
			| h::t ->
				if ( List.nth el co ) < (List.nth h co) then el::h::t
				else h::(insert el t ) 
	in
	let rec insert_sort li' =
		match li' with
			| [] -> []
			| h::t -> insert h ( insert_sort t ) 
	in
	insert_sort l ;;
	
(* pomija z listy studentow, ktorych pole  co (punkty=3) jest puste *)	
let no_empty li co =
	let rec aux li acc =
		match li with
			| [] -> acc
			| h::t ->
				if ( List.nth h co = "" ) then aux t acc
				else aux t (h::acc)
	in aux li [] ;;	

(* obliczenie sredniej liczby punktow biorac pod uwage tylko studentow z wpisanym wynikiem *)
let srednia li =
	let rec aux li' acc =
		match li' with
			| [] -> acc/(List.length (no_empty li 3))
			| h::t ->
				aux t ( (int_of_string(List.nth h 3)) + acc )
				
	in aux (no_empty li 3) 0 ;;

(* tworzenie stringa z listy stringow *)
let make_string = function l ->
		(List.fold_left (String.concat) " " [l])^"\n" ;; 
		
let main () =
	let oc = open_out fileOUT
	and input = ( get () )
	in
	let save_all () =
		output_string oc (("Posortowane wg. nazwiska:\n")^(make_string ( List.map ( make_string ) (sort input 1 ) ))^"\n") ;
		output_string oc (("Posortowane wg. punktacji:\n")^(make_string ( List.map ( make_string ) (sort input 3 ) ))^"\n") ;
		output_string oc (("Osoby z wpisanymi punktami:\n")^(make_string ( List.map ( make_string ) (no_empty input 3 ) ))^"\n") ;
		output_string oc (("Srednia liczba punktow:\n")^(string_of_int (srednia input ) )^"\n") ;
		close_out oc ; 
	in save_all () 
	;;
main() ;;