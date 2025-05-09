open Obric

(* boilerplate *)

module Linked_list = List.With_map (Option)

module Tree = List.With_fold (struct
    type 'a t = 'a list

    let fold = Stdlib.List.fold_left
  end)

let numbers =
  let open Linked_list in
  Cons (3, Some (Cons (5, Some (Cons (2, None)))))
;;

let letters =
  let open Tree in
  Cons
    ( 'H'
    , [ Cons ('E', [ Cons ('L', []); Cons ('L', []) ])
      ; Cons ('O', [ Cons ('!', []); Cons ('\n', []) ])
      ] )
;;

(* tests *)

let () =
  Tester.register "map function over option-list" (fun () ->
    assert (
      Linked_list.map Int.to_string numbers
      = Cons ("3", Some (Cons ("5", Some (Cons ("2", None)))))))
;;

let () =
  Tester.register "fold function over list-tree" (fun () ->
    assert (
      (* ew, logic in tests 😔 *)
      Tree.fold (fun chars char -> char :: chars) [] letters
      |> Stdlib.List.rev
      |> Stdlib.List.to_seq
      |> String.of_seq
      = "HELLO!\n"))
;;
