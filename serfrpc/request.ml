open Protocol_conv_msgpack

module Command = struct  type t =
    | Handshake       [@key "handshake"]
    | Auth            [@key "auth"]
    | Event           [@key "event"]
    | ForceLeave      [@key "force-leave"]
    | Join            [@key "join"]
    | Members         [@key "members"]
    | MembersFiltered [@key "members-filtered"]
    | Tags            [@key "tags"]
    | Stream          [@key "stream"]
    | Monitor         [@key "monitor"]
    | Stop            [@key "stop"]
    | Leave           [@key "leave"]
    | Query           [@key "query"]
    | Respond         [@key "respond"]
    | InstallKey      [@key "install-key"]
    | UseKey          [@key "use-key"]
    | RemoveKey       [@key "remove-key"]
    | ListKeys        [@key "list-keys"]
    | Stats           [@key "stats"]
    | GetCoordinate   [@key "get-coordinate"]
    [@@deriving protocol ~driver:(module Msgpack)]
end

module Header = struct
  type t = {
    command : Command.t; [@key "Command"]
    seq : int; [@key "Seq"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Handshake = struct
  type t = {
    version : int; [@key "Version"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Auth = struct
  type t = {
    auth_key : string; [@key "AuthKey"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Event = struct
  type t = {
    name : string; [@key "Name"]
    payload : string; [@key "Payload"] (* TODO: bytes? *)
    coalesce : bool; [@key "Coalesce"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module ForceLeave = struct
  type t = {
    node : string; [@key "Node"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Join = struct
  type t = {
    existing : string list; [@key "Existing"]
    replay : bool; [@key "Replay"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module MembersFiltered = struct
  type t = {
    tags : (string * string) list; [@key "Tags"]
    status : string; [@key "Status"]
    name : string; [@key "Name"]
  } [@@deriving protocol ~driver:(module Msgpack)]
  (* TODO: optional? *)

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Tags = struct
  type t = {
    tags : (string * string) list; [@key "Tags"]
    delete_tags : string list; [@key "DeleteTags"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Stream = struct
  type t = {
    type2 : string; [@key "Type"] (* TODO: rename *)
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Monitor = struct
  type t = {
    log_level : string; [@key "LogLevel"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Stop = struct
  type t = {
    stop : int; [@key "Stop"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Query = struct
  type t = {
    filter_nodes : string list option; [@key "FilterNodes"]
    filter_tags : (string * string) list option; [@key "FilterTags"]
    request_ack : bool option; [@key "RequestAck"]
    timeout : int option; [@key "Timeout"]
    name : string; [@key "Name"]
    payload : string; [@key "Payload"] (* TODO: bytes? *)
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module Respond = struct
  type t = {
    id : int; [@key "ID"]
    payload : string; [@key "Payload"] (* TODO: bytes? *)
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module InstallKey = struct
  type t = {
    key : string; [@key "Key"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module UseKey = struct
  type t = {
    key : string; [@key "Key"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module RemoveKey = struct
  type t = {
    key : string; [@key "Key"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end

module GetCoordinate = struct
  type t = {
    node : string; [@key "Node"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack
end