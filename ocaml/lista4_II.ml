type 'a mtree = MNode of 'a * 'a forest 
and 'a forest = EmptyForest | Forest of 'a mtree * 'a forest;;

let drzewo = MNode (1, 
                     Forest
                        (MNode (2, 
                           Forest
                              (MNode (4, 
                                 EmptyForest),
                              Forest
                                 (MNode (5, 
                                    EmptyForest),
                                 EmptyForest))),
                        Forest
                           (MNode (3, 
                              Forest
                                 (MNode (6, 
                                    EmptyForest),
                                 Forest
                                    (MNode (7, 
                                       EmptyForest),
                                    EmptyForest))),
                           EmptyForest)));;
						   
	
let wierzcholek (MNode(a,_)) = a ;;
let pod (MNode(_,b)) = b ;;
	
let rec d_forest w =
	match w with
		| EmptyForest -> []
		| Forest(a,b) -> a::d_forest b ;;	
	
let rec preord drzewo =
	match drzewo with
		| [] -> [] 
		| h::t -> (wierzcholek h)::preord (t @ d_forest (pod h) ) ;;
		
preord [drzewo];;

let rec wszerz drzewo =
	match drzewo with
		| [] -> [] 
		| h::t -> (wierzcholek h)::wszerz ( d_forest (pod h) @ t ) ;;
		
wszerz [drzewo];;
		


		
