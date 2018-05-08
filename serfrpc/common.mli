module Bytes : sig
  type t = string
  val t_of_msgpack : Msgpck.t -> t
  val t_to_msgpack : t -> Msgpck.t
end

module SerializableMap : sig
  type t = (string * string) list
  val t_of_msgpack : Msgpck.t -> t
  val t_to_msgpack : t -> Msgpck.t
end

module Address : sig
  type t = int list
  val to_string : t -> string
  val t_of_msgpack : Msgpck.t -> t
  val t_to_msgpack : t -> Msgpck.t
end
