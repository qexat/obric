module type RECURSIVE = sig
  (** A recursive type based on [Base]. *)

  module Base : Types.MONADIC

  type 'a t =
    | Nil
    | Cons of ('a * 'a t Base.t)
end

module type WITH_MAP = sig
  (** The recursive type equipped with functor's [map]. *)

  include RECURSIVE

  (** [map func list] applies [func] to each element of [list]. *)
  val map : ('a -> 'b) -> 'a t -> 'b t
end

module type WITH_FOLD = sig
  (** The recursive type equipped with [fold]. *)

  include RECURSIVE

  (** [fold binary initial list] puts [binary] between every
      element of the [list] and evaluates the resulting
      expression, using [initial] as the start value. *)
  val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
end

module Recurse (Type : Types.MONADIC) : RECURSIVE with module Base = Type = struct
  module Base = Type

  type 'a t =
    | Nil
    | Cons of ('a * 'a t Base.t)
end

module With_map (Type : Interfaces.FUNCTOR) : WITH_MAP with module Base = Type = struct
  module Base = Type
  include (Recurse (Type) : RECURSIVE with module Base := Base)

  let rec map (func : 'a -> 'b) : 'a t -> 'b t = function
    | Nil -> Nil
    | Cons (first, rest) -> Cons (func first, Type.map (map func) rest)
  ;;
end

module With_fold (Type : Interfaces.FOLDABLE) : WITH_FOLD with module Base = Type = struct
  module Base = Type
  include (Recurse (Type) : RECURSIVE with module Base := Base)

  let rec fold (func : 'acc -> 'a -> 'acc) (initial : 'acc) : 'a t -> 'acc = function
    | Nil -> initial
    | Cons (first, rest) -> Type.fold (fold func) (func initial first) rest
  ;;
end
