(*
http://google.com/codesearch?hl=en&q=mandelbrot+lang:caml+show:HkH7mFkwo80:Q8WweL-fjvs:L8n24JLUtLE&sa=N&cd=8&ct=rc&cs_p=http://www.christiankonrad.de&cs_f=christiankonrad/stuff/mandel.ml
http://www.timestretch.com/FractalBenchmark.html#e34bb5c7ff90bc995551a2e8ed80ef9a
*)

open Complex ;;
#load "graphics.cma";;
open Graphics;;

let kolory = [|black;white;red;green;blue;yellow;cyan;magenta|] ;;

let rec mandelbrot i p z =
  if i=0 || norm2 z > 2. then i else mandelbrot (i-1) p (add (mul z z) p) ;;
  
let display () =
	open_graph " 640x640" ;
	for i = -640 to 640 do
		for j = -640 to 640 do
			if (mandelbrot 62 {re=(float i)/.160.;im=(float j)/.160.} {re=0.;im=0.}) = 0 then (
			set_color (kolory.( Random.int 5 ));
			plot (i+320) (j+320) ; )
		done
	done
	;;
	
display() ;;

let _ = read_key () in close_graph() ;;

