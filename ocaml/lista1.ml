(*
Strumie� (tj. niesko�czony ci�g) liczb ca�kowitych mo�emy reprezentowa� za pomoc� funkcji typu int -> int w taki spos�b, �e dla dowolnej takiej funkcji s, s 0 oznacza pierwszy element strumienia, s 1 nast�pny, itd. 
U�ywaj�c powy�szej reprezentacji zdefiniuj nast�puj�ce funkcje na strumieniach (funkcje te powinny by� polimorficzne, tj. powinny dzia�a� na strumieniach o dowolnych elementach): 
hd, tl - funkcje zwracaj�ce odpowiednio g�ow� i ogon strumienia
add - funkcja dodawania zadanej sta�ej do ka�dego elementu strumienia i zwracaj�ca powsta�y w ten spos�b strumie�
map - funkcja, kt�ra dla zadanej operacji 1-argumentowej przetwarza elementy zadanego strumienia za pomoc� tej operacji i zwraca powsta�y w ten spos�b nowy strumie� (tak, jak map na listach sko�czonych)
map2 - jak wy�ej, ale dla zadanych: funkcji 2-argumentowej i 2 strumieni
replace - funkcja, kt�ra dla zadanego indeksu n, warto�ci a i strumienia s zast�puje co n-ty element strumienia s przez warto�� a i zwraca powsta�y w ten spos�b strumie�
take - funkcja, kt�ra dla zadanego indeksu n i strumienia s tworzy nowy strumie� z�o�ony z co n-tego elementu strumienia s
fold - funkcja, kt�ra dla zadanej funkcji f:'a->'b->'a, warto�ci pocz�tkowej a:'a i strumienia s element�w typu 'b tworzy nowy strumie�, kt�rego ka�dy element jest wynikiem "zwini�cia" pocz�tkowego segmentu strumienia s a� do bie��cego elementu w��cznie za pomoc� funkcji f, tj. w strumieniu wynikowym element o indeksie n ma warto�� (... (f (f a s_0) s_1)... s_n) 
tabulate - funkcja tablicowania strumienia, kt�rej warto�ci� powinna by� lista element�w strumienia le��ca w zadanym zakresie indeks�w
Zdefiniuj przyk�adowe strumienie i przetestuj implementacj�. 

W definicji funkcji table wykorzystaj mo�liwo�� definiowania parametr�w opcjonalnych dla funkcji (niech pocz�tek zakresu indeks�w b�dzie opcjonalny i domy�lnie r�wny 0). Przyk�ad. Pisz�c let f ?(x=0) y = x + y deklarujemy, �e pierwszy argument funkcji f o etykiecie x jest opcjonalny, a jego warto�� domy�lna wynosi 0. Funkcj� f mo�na zatem wywo�a� za pomoc� wyra�enia f 3 (= 3) lub jawnie podaj�c warto�� parametru opcjonalnego, za pomoc� sk�adni f ~x:42 3 (= 45).
*)
type s = int -> int ;;
let parzyste:s = ( * ) 2 ;;
let nieparzyste:s = function k -> k * 2 + 1;;


(* HEAD i TAIL *)
let hd (s:s)  = s 0 ;;
let tl (s:s) :s =
	function i -> s (i+1) ;;
(* ADD *)
let add c (s:s) :s = 
	function i -> ( s i ) + c ;;
(* MAP *)
let map fu (s:s) :s =
	function i -> fu ( s i ) ;;
(*MAP2 *)
let map2 fu (x:s) (y:s) :s = 
	function i -> (fu (x i) (y i));;
(* REPLACE *)
let replace a n (s:s) :s =
	function i -> ( if (i mod n = 0 ) then a else s i ) ;;
(*TAKE*)
let take n (s:s) :s = 
	function i -> s ( i * n ) ;;
(* FOLD *)
let rec fold fu a (s:s) (k:int) =
	if ( k = 0 ) then fu a (s 0 )
	else fu ( fold fu a s (k-1) ) (s k ) ;;
(* TABULATE *)
let tabulate ?(z=0) n (s:s) = 
	let rec tab z n (s:s) =
		if ( n - z = 0 ) then []
		else (s z)::(tab (z+1) n s)
	in tab z n s ;;

(* DZIALANIE *)	
(* funkcja pomocnicza dla MAP i MAP2*)
let mn a = function b-> a * b ;;

hd ( tl parzyste) ;;	
hd ( tl ( add 5 parzyste ) ) ;;
tabulate 5 ( (add 3) parzyste ) ;;
tabulate 5 (map (mn 10) nieparzyste );;
tabulate 5 (map2 mn parzyste nieparzyste);;
tabulate 5 (replace 7 3 parzyste );;
tabulate 5 (take 2 parzyste);;
tabulate 10 (fold ( + ) 0 parzyste ) ;;

tabulate ~z:5 10 parzyste ;;
tabulate ~z:0 10 parzyste ;;