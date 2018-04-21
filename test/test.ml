let test =
  let ip = "127.0.0.1" in
  let port = 8082 in
  let address = Unix.ADDR_INET (Unix.inet_addr_of_string ip, port) in

  let%lwt (ic, oc) = Lwt_io.open_connection address in

  let error_handler seq error = print_endline ("Error: " ^ error ^ " (seq: " ^ (string_of_int seq) ^ ")") in
  ignore (Lwt_preemptive.detach (Serfrpc.Io.read_loop ~error_handler) ic);

  let%lwt () = Serfrpc.Io.handshake ~seq:1 oc in
  let%lwt () = Serfrpc.Io.event ~seq:2 ~name:"my_event" ~payload:"my_payload" oc in

  let callback stats = print_endline (Msgpck.show stats) in
  let%lwt () = Serfrpc.Io.stats ~seq:3 ~callback oc in

  let%lwt () = Lwt_unix.sleep 5.0 in

  Lwt_io.close ic

let _ = Lwt_main.run test