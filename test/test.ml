let test =
  let ip = "127.0.0.1" in
  let port = 8082 in
  let address = Unix.ADDR_INET (Unix.inet_addr_of_string ip, port) in

  let%lwt (ic, oc) = Lwt_io.open_connection address in
  ignore (Lwt_preemptive.detach Io.read_loop ic);

  let%lwt () = Io.handshake ~seq:1 oc in
  let%lwt () = Io.event ~seq:2 ~name:"my_event" ~payload:"my_payload" oc in

  let%lwt () = Lwt_unix.sleep 5.0 in

  Lwt_io.close ic

let _ = Lwt_main.run test