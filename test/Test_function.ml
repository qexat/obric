open Obric

(* boilerplate *)

module Arrow = struct
  type ('a, 'b) t = 'a -> 'b

  let apply (func : ('a, 'b) t) (arg : 'a) : 'b = func arg
end

module Recursive = Function.With_apply (Arrow)

let fact =
  Recursive.Fix (fun fact i -> if i = 0 then 1 else i * Recursive.apply fact (i - 1))
;;

(* tests *)

let () =
  Test_manager.register "apply function with fixpoint" (fun () ->
    assert (Recursive.apply fact 3 = 6))
;;
