open Protocol_conv_msgpack

module Header = struct

  type t = {
    seq : int; [@key "Seq"]
    error : string; [@key "Error"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

(* module Handshake *)

(* module Auth *)

(* module Event *)

(* module ForceLeave *)

module Join = struct

  type t = {
    num : int; [@key "Num"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

module Members = struct

  type member = {
    name : string; [@key "Name"]
    addr : int list; [@key "Addr"]
    port : int; [@key "Port"]
    tags : (string * string) list; [@key "Tags"]
    status : string; [@key "Status"]
    protocolMin : int; [@key "ProtocolMin"]
    protocolMax : int; [@key "ProtocolMax"]
    protocolCur : int; [@key "ProtocolCur"]
    delegateMin : int; [@key "DelegateMin"]
    delegateMax : int; [@key "DelegateMax"]
    delegateCur : int; [@key "DelegateCur"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  type t = {
    members : member list; [@key "Members"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

module MembersFiltered = Members

(* module Tags *)

(* TODO: module Stream *)

module Monitor = struct

  type t = {
    log : string; [@key "Log"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

(* module Stop *)

(* module Leave *)

module Query = struct

  module Type = struct
    type t =
      | Ack      [@key "ack"]
      | Response [@key "response"]
      | Done     [@key "done"]
      [@@deriving protocol ~driver:(module Msgpack)]
  end

  type t = {
    type2 : Type.t; [@key "Type"] (* TODO: rename *)
    from : string option; [@key "From"]
    payload : string option; [@key "Payload"] (* TODO: bytes? *)
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

(* module Respond *)

module InstallKey = struct

  type t = {
    messages : (string * string) list; [@key "Messages"]
    num_err : int; [@key "NumErr"]
    num_nodes : int; [@key "NumNodes"]
    num_resp : int; [@key "NumResp"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

module UseKey = InstallKey

module RemoveKey = InstallKey

module ListKeys = struct

  type t = {
    messages : (string * string) list; [@key "Messages"]
    keys : (string * int) list; [@key "Keys"]
    num_err : int; [@key "NumErr"]
    num_nodes : int; [@key "NumNodes"]
    num_resp : int; [@key "NumResp"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

module Stats = struct

  (* TODO: review fields *)

  type agent = {
    name: string; [@key "name"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  type runtime = {
    os: string; [@key "os"]
    arch: string; [@key "arch"]
    version: string; [@key "version"]
    max_procs: string; [@key "max_procs"]
    goroutines: string; [@key "goroutines"]
    cpu_count: string; [@key "cpu_count"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  type serf = {
    failed: string; [@key "failed"]
    left: string; [@key "left"]
    event_time: string; [@key "event_time"]
    query_time: string; [@key "query_time"]
    event_queue: string; [@key "event_queue"]
    members: string; [@key "members"]
    member_time: string; [@key "member_time"]
    intent_queue: string; [@key "intent_queue"]
    query_queue: string; [@key "query_queue"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  type t = {
    agent : agent; [@key "agent"]
    runtime : runtime; [@key "runtime"]
    serf : serf; [@key "serf"]
    tags : (string * string) list; [@key "tags"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end

module GetCoordinate = struct

  type coord = {
    adjustment : int; [@key "Adjustment"]
    error : float; [@key "Error"]
    height : int; [@key "Height"]
    vec : int list; [@key "Vec"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  type t = {
    coord : coord; [@key "Coord"]
    ok : bool; [@key "Ok"]
  } [@@deriving protocol ~driver:(module Msgpack)]

  let to_msgpack = t_to_msgpack
  let from_msgpack = t_of_msgpack

end