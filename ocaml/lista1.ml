(*
Strumieñ (tj. nieskoñczony ci¹g) liczb ca³kowitych mo¿emy reprezentowaæ za pomoc¹ funkcji typu int -> int w taki sposób, ¿e dla dowolnej takiej funkcji s, s 0 oznacza pierwszy element strumienia, s 1 nastêpny, itd. 
U¿ywaj¹c powy¿szej reprezentacji zdefiniuj nastêpuj¹ce funkcje na strumieniach (funkcje te powinny byæ polimorficzne, tj. powinny dzia³aæ na strumieniach o dowolnych elementach): 
hd, tl - funkcje zwracaj¹ce odpowiednio g³owê i ogon strumienia
add - funkcja dodawania zadanej sta³ej do ka¿dego elementu strumienia i zwracaj¹ca powsta³y w ten sposób strumieñ
map - funkcja, która dla zadanej operacji 1-argumentowej przetwarza elementy zadanego strumienia za pomoc¹ tej operacji i zwraca powsta³y w ten sposób nowy strumieñ (tak, jak map na listach skoñczonych)
map2 - jak wy¿ej, ale dla zadanych: funkcji 2-argumentowej i 2 strumieni
replace - funkcja, która dla zadanego indeksu n, wartoœci a i strumienia s zastêpuje co n-ty element strumienia s przez wartoœæ a i zwraca powsta³y w ten sposób strumieñ
take - funkcja, która dla zadanego indeksu n i strumienia s tworzy nowy strumieñ z³o¿ony z co n-tego elementu strumienia s
fold - funkcja, która dla zadanej funkcji f:'a->'b->'a, wartoœci pocz¹tkowej a:'a i strumienia s elementów typu 'b tworzy nowy strumieñ, którego ka¿dy element jest wynikiem "zwiniêcia" pocz¹tkowego segmentu strumienia s a¿ do bie¿¹cego elementu w³¹cznie za pomoc¹ funkcji f, tj. w strumieniu wynikowym element o indeksie n ma wartoœæ (... (f (f a s_0) s_1)... s_n) 
tabulate - funkcja tablicowania strumienia, której wartoœci¹ powinna byæ lista elementów strumienia le¿¹ca w zadanym zakresie indeksów
Zdefiniuj przyk³adowe strumienie i przetestuj implementacjê. 

W definicji funkcji table wykorzystaj mo¿liwoœæ definiowania parametrów opcjonalnych dla funkcji (niech pocz¹tek zakresu indeksów bêdzie opcjonalny i domyœlnie równy 0). Przyk³ad. Pisz¹c let f ?(x=0) y = x + y deklarujemy, ¿e pierwszy argument funkcji f o etykiecie x jest opcjonalny, a jego wartoœæ domyœlna wynosi 0. Funkcjê f mo¿na zatem wywo³aæ za pomoc¹ wyra¿enia f 3 (= 3) lub jawnie podaj¹c wartoœæ parametru opcjonalnego, za pomoc¹ sk³adni f ~x:42 3 (= 45).
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