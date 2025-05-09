(** [register name test] register the [test] under the [name]. *)
val register : string -> (unit -> unit) -> unit

(** [run ()] runs all the registered tests. *)
val run : unit -> unit
