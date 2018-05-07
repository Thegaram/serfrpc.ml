module Bytes = struct
  type t = string
  let t_of_msgpack = Msgpck.to_bytes
  let t_to_msgpack = Msgpck.of_bytes
end

module SerializableMap = struct
  type t = (string * string) list
  let t_of_msgpack m =
    Msgpck.to_map m
    |> List.map (fun (k, v) -> Msgpck.to_string k, Msgpck.to_string v)
  let t_to_msgpack l =
    List.map (fun (k, v) -> Msgpck.of_string k, Msgpck.of_string v) l
    |> Msgpck.of_map
end
