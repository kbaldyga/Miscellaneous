type 'a btree = Leaf of 'a | Node of 'a btree * 'a * 'a btree ;;

let drzewo = Node (Node (Leaf 'a', 'b', Leaf 'c'), 'd', Leaf 'e') ;;
(*
let bfn tree =
	let rec insert i = function 
		| Leaf ( x ) -> Leaf(i)
		| Node ( l , x , r ) ->
			Node (( insert (i+1) l), (i+1) , (insert ( i+1) r ))
	in insert 0 tree;;
	*)
let bfn tree =
	let rec insert i = function 
		| Leaf ( x ) -> Leaf(i)
		| Node ( l , x , r ) ->
			Node (( insert (2*(i+1)) l), (i+1) , (insert ( 2*(i+1)+1) r ))
	in insert 0 tree;;	
	
bfn drzewo ;;