let ( fresh, reset ) =
	let c = ref 0
	in let res n = 
				c:= n 
		and fre s = 
				c := !c+1 ;
				s^(string_of_int !c)
	in (fre, res) ;;
	
fresh "x";;
fresh "x";;
fresh "x";;
fresh "y";;

reset 15;;
fresh "x";;
fresh "x";;