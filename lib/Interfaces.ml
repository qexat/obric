module type FUNCTOR = sig
  include Types.MONADIC

  val map : ('a -> 'b) -> 'a t -> 'b t
end

module type BIFUNCTOR = sig
  include Types.DYADIC

  val map : ('a -> 'c) -> ('b -> 'd) -> ('a, 'b) t -> ('c, 'd) t
end

module type PROFUNCTOR = sig
  include Types.DYADIC

  val map : ('c -> 'a) -> ('b -> 'd) -> ('a, 'b) t -> ('c, 'd) t
end

module type FOLDABLE = sig
  include Types.MONADIC

  val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
end

module type APPLICABLE = sig
  include Types.DYADIC

  val apply : ('a, 'b) t -> 'a -> 'b
end
