module Logging = struct
  let render_error (message : string) : string =
    Printf.sprintf "\x1b[30;41m ERROR \x1b[39;49m %s" message
  ;;

  let render_warning (message : string) : string =
    Printf.sprintf "\x1b[30;43m WARNING \x1b[39;49m %s" message
  ;;

  let render_success (message : string) : string =
    Printf.sprintf "\x1b[30;42m SUCCESS \x1b[39;49m %s" message
  ;;

  let error (message : string) : unit = Printf.eprintf "%s\n" (render_error message)
  let warn (message : string) : unit = Printf.eprintf "%s\n" (render_warning message)
  let succeed (message : string) : unit = Printf.eprintf "%s\n" (render_success message)
end

type status =
  | Passed
  | Failed
  | Skipped

type test =
  { name : string
  ; run : unit -> unit
  ; mutable status : status
  }

let registered_tests : test list ref = ref []

let register (name : string) (run : unit -> unit) : unit =
  if List.exists (fun test -> name = test.name) !registered_tests
  then
    failwith
      (Printf.sprintf "test %s is already registered\n" name |> Logging.render_error);
  registered_tests := { name; run; status = Skipped } :: !registered_tests
;;

let run_test (test : test) : unit =
  let { name; run; _ } = test in
  Printf.eprintf "\x1b[30;45m TEST \x1b[39;49m \x1b[36m%s\x1b[39m - " name;
  match run () with
  | () ->
    test.status <- Passed;
    Printf.eprintf "\x1b[1;32mpassed\x1b[22;39m\n"
  | exception Assert_failure (_, _, _) ->
    test.status <- Failed;
    Printf.eprintf "\x1b[1;31mfailed\x1b[22;39m\n"
;;

let count_failures () : int =
  List.find_all (fun { status; _ } -> status = Failed) !registered_tests |> List.length
;;

let run () =
  match !registered_tests with
  | [] -> Logging.warn "no test was run."
  | tests ->
    List.iter run_test (List.rev tests);
    Printf.eprintf "\n";
    let failures = count_failures () in
    if failures > 0
    then (
      Logging.error (Printf.sprintf "%d test(s) failed" failures);
      exit 1)
    else Logging.succeed "all tests passed!"
;;
