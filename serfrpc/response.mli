module Header : sig
  type t = {
    seq : int;
    error : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Join : sig
  type t = {
    num : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Members : sig
  type member = {
    name : string;
    addr : Common.Bytes.t;
    port : int;
    tags : Common.SerializableMap.t;
    status : string;
    protocolMin : int;
    protocolMax : int;
    protocolCur : int;
    delegateMin : int;
    delegateMax : int;
    delegateCur : int;
  }

  type t = {
    members : member list;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module MembersFiltered : sig
  type t = {
    members : Members.member list;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module UserEventStream : sig
  type t = {
    coalesce: bool;
    event: string;
    ltime: int;
    name: string;
    payload: Common.Bytes.t;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Monitor : sig
  type t = {
    log : string;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Query : sig
  module Type : sig    type t = Ack | Response | Done
  end

  type t = {
    type2 : Type.t;
    from : string option;
    payload : string option;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module InstallKey : sig
  type t = {
    messages : Common.SerializableMap.t;
    num_err : int;
    num_nodes : int;
    num_resp : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module UseKey : sig
  type t = {
    messages : Common.SerializableMap.t;
    num_err : int;
    num_nodes : int;
    num_resp : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module RemoveKey : sig
  type t = {
    messages : Common.SerializableMap.t;
    num_err : int;
    num_nodes : int;
    num_resp : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module ListKeys : sig
  type t = {
    messages : Common.SerializableMap.t;
    keys : (string * int) list;
    num_err : int;
    num_nodes : int;
    num_resp : int;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module Stats : sig
  type agent = {
    name: string;
  }

  type runtime = {
    os: string;
    arch: string;
    version: string;
    max_procs: string;
    goroutines: string;
    cpu_count: string;
  }

  type serf = {
    failed: string;
    left: string;
    event_time: string;
    query_time: string;
    event_queue: string;
    members: string;
    member_time: string;
    intent_queue: string;
    query_queue: string;
  }

  type t = {
    agent : agent;
    runtime : runtime;
    serf : serf;
    tags : Common.SerializableMap.t;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end

module GetCoordinate : sig
  type coord = {
    adjustment : float;
    error : float;
    height : float;
    vec : unit;
  }

  type t = {
    coord : coord;
    ok : bool;
  }

  val to_msgpack : t -> Msgpck.t
  val of_msgpack : Msgpck.t -> t
end
