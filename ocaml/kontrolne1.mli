"pierwsze"
let rec fflattern x = 
	if List.tl x = [] then List.hd x
	else
	( List.hd x )@( fflattern (List.tl x)) ;; 
	
List.iter print_int (fflattern [[1;3;4];[4;5;6]]);;

"drugie"
let rec dzialaj a lista licznik = 
  	if ( lista = [] ) then licznik
  	else if ( a = (List.hd lista) ) then ( dzialaj a ( List.tl lista ) (licznik+1))
  	else (dzialaj a (List.tl lista) licznik);;
	
let count para = dzialaj (fst para) (snd para) 0 ;;	
"
let rec dzialaj para licznik = 
  	if ( ( snd para ) = [] ) then licznik
  	else if ( ( fst para ) = ( List.hd (snd para))) then (dzialaj para (licznik+1))
  	else (dzialaj para licznik);;
"
"trzecie"
let rec duplicate para =
  	if ( (snd para) = 0 ) then []
  	else (fst para)::((duplicate ((fst para),((snd para)-1))));;
	
"czwarte"
let rec sqrt_list lista =
  	if ( lista = []) then []
  	else 
  		((List.hd lista)*(List.hd lista))::(sqrt_list (List.tl lista));;
		
"pi¹te"
let palindrome list = list=(List.rev list);;