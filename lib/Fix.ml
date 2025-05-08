open Types

module type TYPE = sig
  module T : TYPE1

  type 'a t = Fix of ('a * 'a t T.t)

  val unfix : 'a t -> 'a t T.t
end

module Make (T : TYPE1) : TYPE with module T = T = struct
  module T = T

  type 'a t = Fix of ('a * 'a t T.t)

  (* should we ignore the attached value? *)
  let unfix (Fix (_, f) : 'a t) : 'a t T.t = f
end

module With_map (F : Interfaces.FUNCTOR) = struct
  include Make (F)

  let rec map (func : 'a -> 'b) : 'a t -> 'b t = function
    | Fix (x, f) -> Fix (func x, F.map (map func) f)
  ;;
end

module With_fold (F : Interfaces.FOLDABLE) = struct
  include Make (F)

  let rec fold (func : 'acc -> 'a -> 'acc) (initial : 'acc) : 'a t -> 'acc = function
    | Fix (x, f) -> F.fold (fold func) (func initial x) f
  ;;
end
