open Obric

(* boilerplate *)

type nat =
  | O : nat
  | S : nat -> nat

module Function = struct
  type ('a, 'b) t = 'a -> 'b

  let map (func_contra : 'c -> 'a) (func_co : 'b -> 'd) (f : ('a, 'b) t) : ('c, 'd) t =
    fun x -> func_co (f (func_contra x))
  ;;
end

module Fixed = Pro_fix.Make (Function)

let rec fix (func : ('a, 'b) Fixed.t -> 'a -> 'b) : ('a, 'b) Fixed.t =
  Fix (func, fun x -> Fixed.apply (fix func) x)
;;

let nat_to_int =
  (fun (func : (nat, int) Fixed.t) -> function
  | O -> 0
  | S n -> 1 + Fixed.apply func n)
  |> fix
;;

(* test *)

let () =
  Test_manager.register "fixpoint nat_to_int" (fun () ->
    assert (Fixed.apply nat_to_int (S (S O)) = 2))
;;
