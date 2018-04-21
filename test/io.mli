val read_loop : Lwt_io.input_channel -> unit Lwt.t

val handshake : seq:int -> ?version:int -> Lwt_io.output_channel -> unit Lwt.t

val auth : seq:int -> auth_key:string -> Lwt_io.output_channel -> unit Lwt.t

val event : seq:int -> name:string -> payload:string -> ?coalesce:bool -> Lwt_io.output_channel -> unit Lwt.t

val force_leave : seq:int -> node:string -> Lwt_io.output_channel -> unit Lwt.t

val join :
  seq:int -> callback:(Msgpck.t -> unit) -> existing:string list -> ?replay:bool ->
  Lwt_io.output_channel -> unit Lwt.t

val members : seq:int -> callback:(Msgpck.t -> unit) -> Lwt_io.output_channel -> unit Lwt.t

val members_filtered :
  seq:int -> callback:(Msgpck.t -> unit) ->
  ?tags:(string * string) list -> ?status:string -> ?name:string ->
  Lwt_io.output_channel -> unit Lwt.t

val tags :
  seq:int -> ?tags:(string * string) list -> ?delete_tags:string list ->
  Lwt_io.output_channel -> unit Lwt.t

val monitor : seq:int -> callback:(Msgpck.t -> unit) -> log_level:string -> Lwt_io.output_channel -> unit Lwt.t

val stop : seq:int -> stop:int -> Lwt_io.output_channel -> unit Lwt.t

val leave : seq:int -> Lwt_io.output_channel -> unit Lwt.t

val query :
  seq:int -> callback:(Msgpck.t -> unit) ->
  name:string -> payload:string ->
  ?filter_nodes:string list -> ?filter_tags:(string * string) list -> ?request_ack:bool -> ?timeout:int ->
  Lwt_io.output_channel -> unit Lwt.t

val respond : seq:int -> id:int -> payload:string -> Lwt_io.output_channel -> unit Lwt.t

val install_key : seq:int -> callback:(Msgpck.t -> unit) -> key:string -> Lwt_io.output_channel -> unit Lwt.t

val use_key : seq:int -> callback:(Msgpck.t -> unit) -> key:string -> Lwt_io.output_channel -> unit Lwt.t

val remove_key : seq:int -> callback:(Msgpck.t -> unit) -> key:string -> Lwt_io.output_channel -> unit Lwt.t

val list_keys : seq:int -> callback:(Msgpck.t -> unit) -> Lwt_io.output_channel -> unit Lwt.t

val stats : seq:int -> callback:(Msgpck.t -> unit) -> Lwt_io.output_channel -> unit Lwt.t

val get_coordinate : seq:int -> callback:(Msgpck.t -> unit) -> node:string -> Lwt_io.output_channel -> unit Lwt.t