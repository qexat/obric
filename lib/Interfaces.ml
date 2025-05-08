open Types

module type FUNCTOR = sig
  include TYPE1

  val map : ('a -> 'b) -> 'a t -> 'b t
end

module type BIFUNCTOR = sig
  include TYPE2

  val map : ('a -> 'c) -> ('b -> 'd) -> ('a, 'b) t -> ('c, 'd) t
end

module type FOLDABLE = sig
  include TYPE1

  val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
end
