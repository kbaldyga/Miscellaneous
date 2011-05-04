type 'a btree = Leaf | Node of 'a btree * 'a * 'a btree ;;
type 'a array_ = Tab of int * 'a btree ;;

let aempty = Tab(0,Leaf);; 

let rec asub a n = 
	match a with
		| (Tab(s,Node(l,x,r))) ->
			if ( n == 1 ) then x
			else if ( n mod 2 == 0 ) then asub (Tab(s,l)) (n/2)
			else asub(Tab(s,r)) (n/2)
		| (Tab(_,Leaf)) -> failwith "";;
	
let aupdate (Tab(s,tree)) index el =
	let rec insert = function
		(n,Node(l,x,r)) ->
			if ( n == 1 ) then ( Node(l,el,r))
			else if ( n mod 2 == 0 ) then
				(Node(insert(n/2,l),x,r))
			else
				(Node(l,x,insert(n/2,r)))
		| (_,Leaf) -> failwith "brak takiego indeksu"
	in (Tab(s,insert (index,tree))) ;;

let ahiext (Tab(s,tree)) a =
	let rec insert = function
		(n,Node(l,x,r)) ->
			if ( n == 1 ) then ( Node(l,x,r))
			else if ( n mod 2 == 0 ) then
				(Node(insert(n/2,l),x,r))
			else
				(Node(l,x,insert(n/2,r)))
		| (_,Leaf) -> (Node(Leaf,a,Leaf)) 
	in (Tab((s+1),insert ((s+1),tree))) ;;

let ahirem (Tab(s,tree))  =
	let rec insert = function
		(n,Node(l,x,r)) ->
			if ( n == 1 ) then ( Leaf )
			else if ( n mod 2 == 0 ) then
				(Node(insert(n/2,l),x,r))
			else
				(Node(l,x,insert(n/2,r)))
		| (_,Leaf) -> failwith "brak takiego indeksu"
	in (Tab((s-1),insert (s,tree))) ;;	

let tree = Node ( 
					Node(
						Node(
							Node(Leaf,8,Leaf),
							4,
							Node(Leaf,12,Leaf)
							),
						2,
						Node(
							Node(Leaf,10,Leaf),
							6,
							Node(Leaf,14,Leaf))
						),
					1,
					Node(
						Node(
							Node(Leaf,9,Leaf),
							5,
							Node(Leaf,13,Leaf)),
						3,
						Node(
							Node(Leaf,11,Leaf),
						7,
							Node(Leaf,15,Leaf))
						)
				);;
					

		
let tablica = Tab(15,tree);;

asub tablica 14 ;;

aupdate tablica 14 66;;

ahiext ( ahiext tablica 16 ) 17 ;;

ahirem ( ahiext ( ahiext tablica 16 ) 17 ) ;;

















