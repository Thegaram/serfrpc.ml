let my_hash : (int, Msgpck.t -> unit) Hashtbl.t = (Hashtbl.create 1000)

let buffer_size = 4096

let default def opt =
  match opt with | None -> def | Some x -> x

let send_request ~seq ~header ?body ?callback oc =
  let callback = match callback with | Some c -> c | None -> (fun _ -> ()) in
  Hashtbl.add my_hash seq callback;

  let header_size = Msgpck.size header in
  let body_size = match body with
    | None -> 0
    | Some b -> Msgpck.size b
  in

  let required_buffer_size = header_size + body_size in

  let buffer = Bytes.create required_buffer_size in
  let header_length = Msgpck.Bytes.write buffer header in
  let body_length = match body with
    | None -> 0
    | Some b -> Msgpck.Bytes.write ~pos:header_length buffer b
  in
  let request_length = header_length + body_length in

  let%lwt _ = Lwt_io.write_from oc buffer 0 request_length in
  Lwt_io.flush oc

let rec read_loop ?error_handler ic =
  let error_handler = error_handler |> default (fun (_ : int) (_ : string) -> ()) in
  let read_response ic =
    let buffer = Bytes.create buffer_size in
    let%lwt _ = Lwt_io.read_into ic buffer 0 buffer_size in
    (* print_endline (Bytes.to_string buffer); *)
    let (pos, header) = Msgpck.Bytes.read buffer in
    let (_, body) = Msgpck.Bytes.read ~pos buffer in
    (* print_endline (Msgpck.show header);
    print_endline (Msgpck.show body); *)
    Lwt.return (header, body)
  in
  let%lwt (h, b) = read_response ic in
  let header = Response.Header.of_msgpack h in
  (match header.error with
    | "" ->
      let callback = Hashtbl.find my_hash header.seq in
      callback b
    | error ->
      error_handler header.seq error);
  read_loop ic

let handshake ~seq ?version oc =
  let command = Request.Command.Handshake in
  let header = Request.Header.to_msgpack { command; seq } in
  let version = version |> default 1 in
  let body = Request.Handshake.to_msgpack { version } in
  send_request ~seq ~header ~body oc

let auth ~seq ~auth_key oc =
  let command = Request.Command.Auth in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.Auth.to_msgpack { auth_key } in
  send_request ~seq ~header ~body oc

let event ~seq ~name ?payload ?coalesce oc =
  let command = Request.Command.Event in
  let header = Request.Header.to_msgpack { command; seq } in
  let payload = payload |> default "" in
  let coalesce = coalesce |> default false in
  let body = Request.Event.to_msgpack { name; payload; coalesce } in
  send_request ~seq ~header ~body oc

let force_leave ~seq ~node oc =
  let command = Request.Command.ForceLeave in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.ForceLeave.to_msgpack { node } in
  send_request ~seq ~header ~body oc

let join ~seq ~callback ~existing ?replay oc =
  let command = Request.Command.Join in
  let header = Request.Header.to_msgpack { command; seq } in
  let replay = replay |> default false in
  let body = Request.Join.to_msgpack { existing; replay } in
  (* let callback = fun b -> b |> Response.Join.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc

let members ~seq ~callback oc =
  let command = Request.Command.Members in
  let header = Request.Header.to_msgpack { command; seq } in
  let callback body =
    body |> Response.Members.of_msgpack |> callback
  in
  send_request ~seq ~header ~callback oc

let members_filtered ~seq ~callback ?tags ?status ?name oc =
  let command = Request.Command.MembersFiltered in
  let header = Request.Header.to_msgpack { command; seq } in
  let tags = tags |> default [] in
  let status = status |> default "" in
  let name = name |> default "" in
  let body = Request.MembersFiltered.to_msgpack { tags; status; name } in
  let callback body =    
    body |> Response.MembersFiltered.of_msgpack |> callback
  in
  send_request ~seq ~header ~body ~callback oc

let tags ~seq ?tags ?delete_tags oc =
  let command = Request.Command.Tags in
  let header = Request.Header.to_msgpack { command; seq } in
  let tags = tags |> default [] in
  let delete_tags = delete_tags |> default [] in
  let body = Request.Tags.to_msgpack { tags; delete_tags } in
  send_request ~seq ~header ~body oc

let stream ~seq ~callback ~type2 oc =
  let command = Request.Command.Stream in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.Stream.to_msgpack { type2 } in
  (* let callback = fun b -> b |> Response.Stream.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc

let monitor ~seq ~callback ~log_level oc =
  let command = Request.Command.Monitor in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.Monitor.to_msgpack { log_level } in
  let callback body =
    body |> Response.Monitor.of_msgpack |> callback
  in
  send_request ~seq ~header ~body ~callback oc

let stop ~seq ~stop oc =
  let command = Request.Command.Stop in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.Stop.to_msgpack { stop } in
  send_request ~seq ~header ~body oc

let leave ~seq oc =
  let command = Request.Command.Leave in
  let header = Request.Header.to_msgpack { command; seq } in
  send_request ~seq ~header oc

let query ~seq ~callback ~name ~payload ?filter_nodes ?filter_tags ?request_ack ?timeout oc =
  let command = Request.Command.Query in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.Query.to_msgpack { name; payload; filter_nodes; filter_tags; request_ack; timeout } in
  (* let callback = fun b -> b |> Response.Query.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc

let respond ~seq ~id ~payload oc =
  let command = Request.Command.Respond in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.Respond.to_msgpack { id; payload } in
  send_request ~seq ~header ~body oc

let install_key ~seq ~callback ~key oc =
  let command = Request.Command.InstallKey in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.InstallKey.to_msgpack { key } in
  (* let callback = fun b -> b |> Response.InstallKey.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc

let use_key ~seq ~callback ~key oc =
  let command = Request.Command.UseKey in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.UseKey.to_msgpack { key } in
  (* let callback = fun b -> b |> Response.UseKey.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc

let remove_key ~seq ~callback ~key oc =
  let command = Request.Command.RemoveKey in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.RemoveKey.to_msgpack { key } in
  (* let callback = fun b -> b |> Response.RemoveKey.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc

(* let callback = fun b ->
    print_endline (Msgpck.show b);
    try b |> Response.ListKeys.of_msgpack; ()
    with e -> print_endline (Printexc.to_string e);
    (* b |> Response.ListKeys.of_msgpack |> callback *)
  in *)
let list_keys ~seq ~callback oc =
  let command = Request.Command.ListKeys in
  let header = Request.Header.to_msgpack { command; seq } in
  (* let callback = fun b -> b |> Response.ListKeys.of_msgpack |> callback in *)
  send_request ~seq ~header ~callback oc

let stats ~seq ~callback oc =
  let command = Request.Command.Stats in
  let header = Request.Header.to_msgpack { command; seq } in
  (* let callback = fun b -> b |> Response.Stats.of_msgpack |> callback in *)
  send_request ~seq ~header ~callback oc

let get_coordinate ~seq ~callback ~node oc =
  let command = Request.Command.GetCoordinate in
  let header = Request.Header.to_msgpack { command; seq } in
  let body = Request.GetCoordinate.to_msgpack { node } in
  (* let callback = fun b -> b |> Response.GetCoordinate.of_msgpack |> callback in *)
  send_request ~seq ~header ~body ~callback oc
