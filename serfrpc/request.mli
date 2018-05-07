module Command : sig
  type t =
    | Handshake
    | Auth
    | Event
    | ForceLeave
    | Join
    | Members
    | MembersFiltered
    | Tags
    | Stream
    | Monitor
    | Stop
    | Leave
    | Query
    | Respond
    | InstallKey
    | UseKey
    | RemoveKey
    | ListKeys
    | Stats
    | GetCoordinate
end

module Header : sig
  type t = {
    command : Command.t;
    seq : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Handshake : sig
  type t = {
    version : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Auth : sig
  type t = {
    auth_key : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Event : sig
  type t = {
    name : string;
    payload : Common.Bytes.t;
    coalesce : bool;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module ForceLeave : sig
  type t = {
    node : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Join : sig
  type t = {
    existing : string list;
    replay : bool;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module MembersFiltered : sig
  type t = {
    tags : Common.SerializableMap.t;
    status : string;
    name : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Tags : sig
  type t = {
    tags : Common.SerializableMap.t;
    delete_tags : string list;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Stream : sig
  type t = {
    type2 : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Monitor : sig
  type t = {
    log_level : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Stop : sig
  type t = {
    stop : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Query : sig
  type t = {
    filter_nodes : string list option;
    filter_tags : Common.SerializableMap.t option;
    request_ack : bool option;
    timeout : int option;
    name : string;
    payload : Common.Bytes.t;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Respond : sig
  type t = {
    id : int;
    payload : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module InstallKey : sig
  type t = {
    key : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module UseKey : sig
  type t = {
    key : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module RemoveKey : sig
  type t = {
    key : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module GetCoordinate : sig
  type t = {
    node : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end
