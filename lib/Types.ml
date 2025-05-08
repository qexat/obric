module type TYPE0 = sig
  type t
end

module type TYPE1 = sig
  type 'a t
end

module type TYPE2 = sig
  type ('a, 'b) t
end
