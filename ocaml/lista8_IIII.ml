type 'a lnode = { item : 'a ; mutable next: 'a lnode } ;;

let mk_circular_list e =
	let rec x = { item=e;next=x}
	in x ;;
	
let insert_tail e l =
	let x = { item=e ; next=l.next }
	in l.next <- x; x;;

let elim_head l = l.next <- (l.next).next; l ;;
	
let generator_listy n =
	let rec l = mk_circular_list 1
	and
	make n =
		if ( n = 1 ) then []
		else n::(make (n-1) ) 
	in List.fold_right insert_tail ( make n ) l;;
	
let destruktor l n =
	let rec aux n' li acc =
		if ( li == ( li.next ) ) then (List.rev (li.item::acc))
		else 
			if ( n' = 1 ) then 
				aux n (elim_head li ) (li.next.item::acc )
			else
				aux (n'-1) (li.next) acc	
	in aux n l [] ;;

let jozef n m =
	destruktor ( generator_listy n ) m ;;
	
jozef 41 3 ;;
jozef 7 3 ;;

