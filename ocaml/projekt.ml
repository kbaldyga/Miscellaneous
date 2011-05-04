#load "graphics.cma";;
open Graphics;;

(* operacje na wektorach *)
type vec = float array ;;
let vec3 x y z = [| x ; y ; z |] ;;
let vzero = vec3 0. 0. 0. ;;
let ( *| ) a v = [| a *. v.(0) ; a *. v.(1) ; a *. v.(2) |] ;;
let ( +| ) a b = [| a.(0) +. b.(0) ; a.(1) +. b.(1) ; a.(2) +. b.(2) |] ;;
let ( -| ) a b = [| a.(0) -. b.(0) ; a.(1) -. b.(1) ; a.(2) -. b.(2) |] ;;
let ( |*| ) a b = [| a.(0) *. b.(0) ; a.(1) *. b.(1) ; a.(2) *. b.(2) |] ;;
let dot a b = a.(0) *. b.(0) +. a.(1) *. b.(1) +. a.(2) *. b.(2) ;;
let len2 a = dot a a ;;
let len a = sqrt ( len2 a ) ;;
let norm a = ( 1. /. len a ) *| a ;;

(* typy wykorzystywane w programie:
	* promien : sk�d -> dok�d
	* �wiat�o : pozycja, kolor
	* materia� : kolor , wsp�czynniki: �wiat�a rozproszonego, refleksyjnego i odbicia
	* obiekt : pozycja, promien, materia�
*)
type ray = { origin : vec ; direction : vec } ;;
type light = { lposition : vec ; lcolor : vec } ;;
type material = { mcolor : vec ; specular : float ; diffusive : float ; reflection : float} ;;
type prim_sphere = { position : vec ; radius : float ; pmaterial : material } ;;

let normal (prim:prim_sphere) (pos:vec) =
		(1.0 /. prim.radius) *| (pos -| prim.position ) ;;

(* pot�ga *)
let pow a b =
	let rec aux b acc =
		if b = 1 then acc
		else aux (b-1) (a*.acc)
	in aux b a ;;
(*
	funkcja dla zadanego promienia i listy elementow, znajduje element na przecieciu z promieniem, oraz odleglosc od niego,
	jako argumenty przyjmuje:
		- promie�
		- najblizszy obiekt ( dopiero wyliczany i zwracany, mo�e by� tylko jeden, dlatego pami�tany jako argument )
		- list� wszystkich obiekt�w
		- odleg�o�� obiektu kt�ry jest najbli�ej ( r�wnie� dopiero wyliczane )
	algorytm znajdowania przeci�cia wektora z kul� w przestrzeni 3D znaleziony w internecie
*)
let rec intersect (ray:ray) (primm:prim_sphere) (primm_list: 'prim_sphere list) (distance:float)= 
	match primm_list with
		| [] -> (distance,primm)
		| h::t ->	
		let v = h.position -| ray.origin
		in let b = (dot v ray.direction)
		in let det = ( b *. b ) -. (dot v v) +. 
			(h.radius *.
				h.radius )
		in 
			if det < 0. then ( intersect ray primm t distance )
			else
				let det = sqrt det in
				let t2 = b +. det in
					if t2 < 0. then (intersect ray primm t distance) else
						let t1 = b -. det in
							if ( t1 < distance && t1 > 0. ) then
								( intersect ray h t t1 )
							else if ( t2 < distance ) then
								( intersect ray h t t2 )
							else ( intersect ray primm t distance )
;;
(*
	funkcja modyfikuje kolor danego pixela poprzez obliczenia na swiat�ach, argumenty:
		- promie�
		- najblizszy obiekt
		- list� �wiate� na scenie
		- dany kolor, kt�ry b�dzie modyfikowany
		- odleg�o�� najbli�szego obiektu
*)
let rec obliczenia_swiatla (ray:ray) (obiekt:prim_sphere) (light_list: 'light list) (kolor:vec) (odleglosc:float)=
	match light_list with 
		| [] -> kolor
		| h::t ->
			let pi = ray.origin +| ( odleglosc *| ray.direction )
			and prim_color = obiekt.pmaterial.mcolor
			in
			let l = norm ( h.lposition -| pi )
			and n = normal obiekt pi
			in
			let oblicz_diffusive = (* shader dla odbicia rozproszonego *)
				let dott = dot l n
				in
					if ( dott > 0.01 ) then
						let diff = dott *. obiekt.pmaterial.diffusive in 
						(kolor +| ( diff *| (h.lcolor |*| prim_color ))) 
					else kolor
			and oblicz_specular = (* shader dla odbicia refleksyjnego *)
				let r = l -| ( (2.0 *. ( dot l n )) *| n )
				in let dott = dot ray.direction r
				in
				if ( dott > 0. ) then 
					let dott = pow dott 20 	in 
					let spec = dott *. obiekt.pmaterial.specular in
					kolor +| ( spec *| h.lcolor )
				else kolor
			in
		if ( obiekt.pmaterial.diffusive > 0. ) then (
			if ( obiekt.pmaterial.specular > 0. ) then
				obliczenia_swiatla ray obiekt t ( oblicz_diffusive +| oblicz_specular |*| [|0.7;0.7;0.7|]) odleglosc
			else
				obliczenia_swiatla ray obiekt t ( oblicz_diffusive |*| [|0.7;0.7;0.7|]) odleglosc
			)
		else if ( obiekt.pmaterial.specular > 0. ) then
				obliczenia_swiatla ray obiekt t ( oblicz_specular |*| [|0.7;0.7;0.7|] ) odleglosc
		else
			obliczenia_swiatla ray obiekt t kolor odleglosc
	;;
(*
	funkcja �ledz�ca dany promie�, sprawdza czy promie� przeci�� si� z czym�, je�li tak, to wywo�uje obliczenia na kolorze
	oraz je�li obiekt odbija inne obiekty wywo�uje rekurencyjnie siebie, ze �r�d�em promienia w miejscu trafienia obiektu.
		- promie�
		- lista obiekt�w na scenie
		- lista �wiate�
		- g��boko�� rekursji ( w przypadku obiekt�w odbijaj�cych
*)
let rec trace (ray:ray) (primitive_list: 'prim_sphere list ) (light_list: 'light list ) (refl_depth:int) =
	(* (dystans do najblizszego elementu, najblizszy_element) *)
	let (odleglosc,obiekt) =
		intersect ray (List.nth primitive_list 0) primitive_list infinity 
	in
	let pi = ray.origin +| ( odleglosc *| ray.direction ) (* miejsce przeci�cia promienia z obiektem *)
	and prim_color = obiekt.pmaterial.mcolor
	in
	let odbicie kkolor = (* je�li obiekt ma powierzchni� odbijaj�c�, z danego miejsca przeci�cia z promieniem wystrzeliwujemy 
							nowy promie� uzyskuj�c odbicie *)
		let n = normal obiekt pi in
		let r = ray.direction -| ((dot ray.direction n ) *. 2. ) *| n in
		let rcol = ( trace ( { origin=pi+|0.0000001*|r;direction=r} ) primitive_list light_list (refl_depth+1) )
		in
		kkolor +| (obiekt.pmaterial.reflection *| rcol ) |*| prim_color 
	in		
	
	if ( odleglosc == infinity ) then (* trafienie w nic *)
		vzero
	else (* trafienie w obiekt odbijaj�cy *)
		if ( obiekt.pmaterial.reflection > 0. && refl_depth < 4 ) then
			odbicie ( 	obliczenia_swiatla ray obiekt (light_list) (vzero) odleglosc )
		else (* trafienie w obiekt nieodbijaj�cy *)
						obliczenia_swiatla ray obiekt (light_list) (vzero) odleglosc

	;;
(*
	tworzenie wirtualnego planu, translacja kolor�w do system�w rgb, wywo�anie funkcji trace dla ka�dego piksela. argumenty:
		- po�o�enie kamery
		- lista obiekt�w
		- lista �wiate�
		- rozmar ekranu
*)
let render (primitive_list: 'prim_sphere list) (light_list: 'light list ) (w,h) =
	let camera = [|0.;0.;-15.|] in
	let wx1 = -2. (* rozmiar wirtualnego ekranu, lewy r�g = -2, prawy 2 *)
	and wx2 = 2.
	and wy1 = -1.5 (* g�ra -1.5, odwrotnie, bo tak jest w bibliotece Graphics *)
	and wy2 = 1.5 (* d� 1.5 *)
	in
	let dx = (wx2-.wx1)/.(float_of_int w) (* rozmiar wirtualnego piksela *)
	and dy = (wy2-.wy1)/.(float_of_int h)
	in let sx = ref wx1
	and sy = ref wy1
	and rgb = ref [|0.;0.;0.|]
	and tnij_kolory arr = (* kolory zapisywane w originale w formacie od 0. do 1., wi�kszy wyb�r ni� tylko 256 kolor�w
							 lecz podczas wy�wietlania na ekran i tak musz� by� przyci�te do formatu 0 - 255, dlatego je�li co� jest > 256 lub < 0 zostaje obci�te
						   *)
			if ( arr.(0) > 256. ) then arr.(0) <- 255.
			else if ( arr.(0) < 0. ) then arr.(0) <- 0. ;
			if ( arr.(1) > 256. ) then arr.(1) <- 255.
			else if ( arr.(1) < 0. ) then arr.(1) <- 0. ;
			if ( arr.(2) > 256. ) then arr.(2) <- 255.
			else if ( arr.(2) < 0. ) then arr.(2) <- 0. ;
			arr 
	in
	let main =
	open_graph "640x480" ;
	for y=0 to (h-1) do
		sx:=wx1 ;
		for x=0 to (w-1) do
			let promien = {origin=camera;direction=norm( [|!sx;!sy;0.|] -| camera )}
			in 
			rgb := tnij_kolory ( 256. *| 
				(trace promien primitive_list light_list 0) ) ;
			set_color ( Graphics.rgb 
					( int_of_float !rgb.(0) )
					( int_of_float !rgb.(1) )
					( int_of_float !rgb.(2) ) ) ;
			plot x y  ;
			sx:= !sx+.dx ;
		done ;
		sy:=!sy+.dy;
	done ;
	in main 
	;;

(*
	materia�y u�yte na scenie
	swiatlo rozproszone - diffusive
	swiatlo refleksyjne - specular - rekleksy/blyski na obiektach powstaja gdy obiekt ma wysokie specular
*)
let polishedstone = { mcolor =[|0.;1.;0.|] ; specular =0.3 ; diffusive =0.4 ; reflection=0.9} ;;
let bluestone = { mcolor = [|0.8;0.5;1.|] ; specular = 0.3 ; diffusive = 0.4 ; reflection=0.5} ;;
let paper = {mcolor=[|1.;1.;0.8|];specular=0.4;diffusive=0.5;reflection=0.};;
let paper2 = {mcolor=[|0.7;0.7;0.|];specular=0.2;diffusive=0.4;reflection=0.};;
let black = {mcolor=[|0.;0.;0.|];specular=0.;diffusive=0.;reflection=0.};;

let swiatlo ={ lposition =[|2.;2.;-3.|] ; lcolor =[|2.;2.;2.|] } ;;
let swiatlo2 = { lposition = [| -2. ;2.;-3.|] ; lcolor = [|0.4 ; 0.4;0.3|]};;


let s1 = render  	([
					{position=[|0.; -10.; 12.|];radius=10.;pmaterial=paper};
					{position=[|1.;0.;0.|];radius=0.45;pmaterial=polishedstone};
					{position=[|0.;0.;-0.5|];radius=0.42;pmaterial=bluestone}; 
					{position=[|-1.;0.;-1.|];radius=0.4;pmaterial=paper};
					{position=[|-1.5;1.;0.|];radius=0.5;pmaterial=bluestone};
					])
				([swiatlo;swiatlo2])
				(640,480) ;;

let s2 = render 	([
					{position=[|0.; -10.; 12.|];radius=10.;pmaterial=paper};
					{position=[|1.;0.;0.|];radius=0.45;pmaterial=polishedstone};
					{position=[|0.;-1.;-0.5|];radius=0.42;pmaterial=bluestone}; 
					{position=[|-1.;0.;-1.|];radius=0.4;pmaterial=paper2};
					{position=[|-1.5;1.;0.|];radius=0.5;pmaterial=bluestone};
					])
				([swiatlo;swiatlo2])
				(640,480) ;;
				
let s3 = render  	([
					{position=[|0.; -10.; 12.|];radius=10.;pmaterial=paper};
					{position=[|0.;0.;0.|];radius=1.;pmaterial=paper2};
					(* uszy *)
					{position=[|1.;0.6;0.5|];radius=0.22;pmaterial=polishedstone}; 
					{position=[|-1.;0.6;0.5|];radius=0.22;pmaterial=polishedstone};
					(* nos *)
					{position=[|0.;0.4;-0.8|];radius=0.3;pmaterial=paper2};
					{position=[|0.1;0.45;-1.|];radius=0.08;pmaterial=black};
					{position=[|-0.1;0.45;-1.|];radius=0.08;pmaterial=black};
					(* oczy *)
					{position=[|-0.3;0.6;-0.6|];radius=0.14;pmaterial=bluestone};
					{position=[|0.3;0.6;-0.6|];radius=0.14;pmaterial=bluestone};
					{position=[|0.28;0.6;-0.7|];radius=0.02;pmaterial=black};
					(* buzia *)
					{position=[|0.12;-0.2;-0.8|];radius=0.25;pmaterial=black};
					])
				([swiatlo;swiatlo2])
				(640,480) ;;				
let _ = read_key () in close_graph() ;;	
