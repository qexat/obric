open Obric

(* boilerplate *)

module Function = struct
  type ('a, 'b) t = 'a -> 'b

  let apply (func : ('a, 'b) t) (arg : 'a) : 'b = func arg
end

module Recursive = Fix.With_apply (Function)

let fact =
  Recursive.Fix (fun fact i -> if i = 0 then 1 else i * Recursive.apply fact (i - 1))
;;

(* tests *)

let () =
  Tester.register "apply function with fixpoint" (fun () ->
    assert (Recursive.apply fact 3 = 6))
;;
