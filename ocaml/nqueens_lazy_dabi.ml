(* nqueens.ml *)
(* Przykladowe rozwiazanie oparte na listach gorliwych. *)

open List;;

(*
let fail = []
*)
let succeed a = [a]
let collect = concat

let rec from_a_to_b a b =
  if a > b then [] else a :: from_a_to_b (a+1) b

let is_solution s n = 
  length s = n

let is_safe s n =
  let rec nodiag = function 
      (i, []) -> true
    | (i, q :: qs) -> abs (n - q) <> i && nodiag (i+1, qs)
  in not (mem n s) && nodiag (1, s) 

let nqueens n =
  let enum_1_n = from_a_to_b 1 n
  in let rec solutions_from s =
      if is_solution s n
      then succeed s
      else collect (map solutions_from (map (fun h -> h :: s) (filter (is_safe s) enum_1_n)))
     in solutions_from []
