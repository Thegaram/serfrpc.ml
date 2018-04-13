let send_request ?body (ic, oc) header =
  let buffer_size = 4096 in
  let obuffer = Buffer.create buffer_size in
  let ibuffer = Bytes.create buffer_size in

  ignore (Msgpck.BytesBuf.write obuffer header);
  (match body with
    | None -> ()
    | Some b -> ignore (Msgpck.BytesBuf.write obuffer b));

  Buffer.output_buffer oc obuffer;
  flush oc;

  ignore (input ic ibuffer 0 buffer_size);
  let (pos, header) = Msgpck.Bytes.read ibuffer in
  let (_, body) = Msgpck.Bytes.read ~pos ibuffer in

  (header, body)

let _ =
  let sockaddr = Unix.ADDR_INET (Unix.inet_addr_of_string "127.0.0.1", 8082) in
  let (ic, oc) = Unix.open_connection sockaddr in

  let header = Request.Header.to_msgpack { command = Request.Command.Handshake; seq = 1 } in
  let body = Request.Handshake.to_msgpack { version = 1 } in
  let (h, b) = send_request (ic, oc) header ?body:(Some body) in
  print_endline (Msgpck.show h);

  let header = Request.Header.to_msgpack { command = Request.Command.Event; seq = 2 } in
  let body = Request.Event.to_msgpack { name = "hey!"; payload = ""; coalesce = false } in
  let (h, b) = send_request (ic, oc) header ?body:(Some body) in
  print_endline (Msgpck.show h);

  let header = Request.Header.to_msgpack { command = Request.Command.Members; seq = 3 } in
  let (h, b) = send_request (ic, oc) header ?body:None in
  print_endline (Msgpck.show h);
  print_endline (Msgpck.show b);

  let header = Request.Header.to_msgpack { command = Request.Command.Stats; seq = 4 } in
  let (h, b) = send_request (ic, oc) header ?body:None in
  print_endline (Msgpck.show h);
  print_endline (Msgpck.show b);

  Unix.shutdown_connection ic;