module type RECURSIVE = sig
  (** A recursive type based on [Base]. *)

  module Base : Types.DYADIC

  type ('a, 'b) t = Fix of (('a, 'b) t, ('a, 'b) Base.t) Base.t
end

module type WITH_APPLY = sig
  (** The recursive type equipped with [apply]. *)

  include RECURSIVE

  (** [apply func arg] applies [func] to [arg]. *)
  val apply : ('a, 'b) t -> 'a -> 'b
end

module Recurse (Type : Types.DYADIC) : RECURSIVE with module Base = Type = struct
  module Base = Type

  type ('a, 'b) t = Fix of (('a, 'b) t, ('a, 'b) Base.t) Base.t
end

module With_apply (Type : Interfaces.APPLICABLE) : WITH_APPLY with module Base = Type =
struct
  module Base = Type
  include (Recurse (Type) : RECURSIVE with module Base := Base)

  let apply (func : ('a, 'b) t) (arg : 'a) : 'b =
    match func with
    | Fix f -> Type.apply (Type.apply f func) arg
  ;;
end
