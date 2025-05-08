open Obric
module Tree = Fix.With_map (List)

let my_list : int Tree.t = Fix (3, [ Fix (5, [ Fix (2, []) ]); Fix (4, []) ])

(* tests *)

let () =
  Test_manager.register "map over fix-list" (fun () ->
    assert (
      Tree.map Int.to_string my_list
      = Fix ("3", [ Fix ("5", [ Fix ("2", []) ]); Fix ("4", []) ])))
;;
