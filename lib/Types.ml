module type NILADIC = sig
  type t
end

module type MONADIC = sig
  type 'a t
end

module type DYADIC = sig
  type ('a, 'b) t
end

module Id = struct
  type 'a t = 'a

  let map (func : 'a -> 'b) : 'a t -> 'b t = function
    | value -> func value
  ;;

  let fold (func : 'acc -> 'a -> 'acc) (initial : 'acc) : 'a t -> 'acc = function
    | value -> func initial value
  ;;

  let join (value : 'a t t) : 'a t = value
  let bind (value : 'a t) (func : 'a -> 'b t) : 'b t = func value
end
