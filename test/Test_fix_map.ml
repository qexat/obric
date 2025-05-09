open Obric
module Tree = Fix.With_map (List)
module Linked = Fix.With_map (Option)

let my_tree : int Tree.t = Fix (3, [ Fix (5, [ Fix (2, []) ]); Fix (4, []) ])
let my_list : string Linked.t = Fix ("43", Some (Fix ("17", Some (Fix ("0", None)))))

(* tests *)

let () =
  Test_manager.register "map over fix-list" (fun () ->
    assert (
      Tree.map Int.to_string my_tree
      = Fix ("3", [ Fix ("5", [ Fix ("2", []) ]); Fix ("4", []) ])))
;;

let () =
  Test_manager.register "map over fix-option" (fun () ->
    assert (
      Linked.map int_of_string my_list = Fix (43, Some (Fix (17, Some (Fix (0, None)))))))
;;
