open Types

module type TYPE = sig
  module T : TYPE2

  type ('a, 'b) t = Fix of ((('a, 'b) t -> 'a -> 'b) * ('a, 'b) T.t)

  val unfix : ('a, 'b) t -> ('a, 'b) T.t
end

module Make (T : TYPE2) : TYPE with module T = T = struct
  module T = T

  type ('a, 'b) t = Fix of ((('a, 'b) t -> 'a -> 'b) * ('a, 'b) T.t)

  let unfix (Fix (_, f)) = f
end

module With_apply (T : TYPE2) = struct
  include Make (T)

  let apply (func : ('a, 'b) t) (arg : 'a) : 'b =
    match func with
    | Fix (f, fix) -> f (Fix (f, fix)) arg
  ;;
end
