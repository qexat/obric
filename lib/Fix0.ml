open Types

module type TYPE = sig
  module T : TYPE1

  type t = Fix of t T.t

  val unfix : t -> t T.t
end

module Make (T : TYPE1) : TYPE with module T = T = struct
  module T = T

  type t = Fix of t T.t

  let unfix (Fix f : t) : t T.t = f
end

module With_map (F : Interfaces.FUNCTOR) = struct
  include Make (F)

  let rec map (func : 'a -> 'b) : t -> t = function
    | Fix f -> Fix (F.map (map func) f)
  ;;
end

module With_fold (F : Interfaces.FOLDABLE) = struct
  include Make (F)

  let rec fold (func : 'acc -> 'a -> 'acc) (initial : 'acc) : t -> 'acc = function
    | Fix f -> F.fold (fold func) initial f
  ;;
end
