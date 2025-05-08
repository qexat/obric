open Obric

(* boilerplate *)

module List = struct
  include List

  (* for Interfaces.FOLDABLE *)
  let fold = fold_left
end

module Tree = Fix.With_fold (List)

let my_list : int Tree.t = Fix (3, [ Fix (5, [ Fix (2, []) ]); Fix (4, []) ])

(* tests *)

let () =
  Test_manager.register "fold over fix-list" (fun () ->
    assert (Tree.fold ( + ) 0 my_list = 14))
;;
