exception Unimplemented of string

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

module Address = struct
  type t = int list

  let to_string t = 
    let string_array = List.map string_of_int t in
    String.concat "." string_array

  let t_of_msgpack m =
    let bytes = Msgpck.to_bytes m in
    let bytes_length = String.length bytes in    

    let get_ip n =
      let numpos = bytes_length - (4 - n) in
      String.get bytes numpos |> Char.code
    in
    List.init 4 get_ip

  let t_to_msgpack l =
    raise (Unimplemented "t_to_msgpack is not implemented")
end
