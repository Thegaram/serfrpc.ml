open Lwt.Infix

let my_hash : (int, Msgpck.t -> unit) Hashtbl.t = (Hashtbl.create 1000)

let buffer_size = 4096
let buffer = Bytes.create buffer_size

let send_request ?body oc command seq =
  let header = Request.Header.to_msgpack { command; seq } in

  let header_length = Msgpck.Bytes.write buffer header in
  let body_length = match body with
    | None -> 0
    | Some b -> Msgpck.Bytes.write ~pos:header_length buffer b
  in
  let request_length = header_length + body_length in

  let%lwt _ = Lwt_io.write_from oc buffer 0 request_length in
  Lwt_io.flush oc

let rec read_loop ic =
  let read_response ic =
    let%lwt _ = Lwt_io.read_into ic buffer 0 buffer_size in
    let (pos, header) = Msgpck.Bytes.read buffer in
    let (_, body) = Msgpck.Bytes.read ~pos buffer in
    Lwt.return (header, body)
  in
  let%lwt (h, b) = read_response ic in
  let header = Response.Header.from_msgpack h in
  let seq = header.seq in
  let callback = Hashtbl.find my_hash seq in
  callback b;
  read_loop ic

let perform_request ?body ?callback (ic, oc) command seq =
  let callback = match callback with | Some c -> c | None -> (fun _ -> ()) in
  Hashtbl.add my_hash seq callback;
  send_request ?body oc command seq

let test =
  let address = Unix.ADDR_INET (Unix.inet_addr_of_string "127.0.0.1", 8082) in
  let%lwt (ic, oc) = Lwt_io.open_connection address in

  ignore (Lwt_preemptive.detach read_loop ic);

  let body = Request.Handshake.to_msgpack { version = 1 } in
  let%lwt _ = perform_request (ic, oc) Request.Command.Handshake 1 ~body in

  let body = Request.Event.to_msgpack { name = "hey!"; payload = ""; coalesce = false } in
  let%lwt _ = perform_request (ic, oc) Request.Command.Event 2 ~body in

  let callback = fun b -> print_endline (Msgpck.show b) in
  let%lwt _ = perform_request (ic, oc) Request.Command.Members 3 ~callback in

  let%lwt _ = perform_request (ic, oc) Request.Command.Members 4 ~callback in

  let%lwt () = Lwt_unix.sleep 1.0 in

  Lwt_io.close ic

let _ = Lwt_main.run test