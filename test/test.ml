let print character =
  let code = Char.code character in
  Printf.printf "%2.2X " code

let print_msgpck data =
  let size = Msgpck.Bytes.size data in
  print_int size;
  print_endline " <- size";
  let buf = Bytes.create size in
  print_endline "buf created";
  Msgpck.Bytes.write buf data;
  print_endline "buf written";
  Bytes.iter print buf;
  print_endline ""

let test =
  let ip = "127.0.0.1" in
  let port = 7373 in
  let address = Unix.ADDR_INET (Unix.inet_addr_of_string ip, port) in

  let%lwt (ic, oc) = Lwt_io.open_connection address in

  let error_handler seq error = print_endline ("Error: " ^ error ^ " (seq: " ^ (string_of_int seq) ^ ")") in
  ignore (Lwt_preemptive.detach (Serfrpc.Io.read_loop ~error_handler) ic);

  let%lwt () = Serfrpc.Io.handshake ~seq:1 oc in

  let digestValidData data =
    print_endline "arrived";
    try
      print_endline (Msgpck.show data);
      print_msgpck data;
      let test = data |> Serfrpc.Response.UserEventStream.from_msgpack in
      print_endline (test.payload);
      ()
    with e -> print_endline (Printexc.to_string e);
  in

  let cb data =
    match Msgpck.show data with
      | "0" -> ();
      | _ -> digestValidData data
  in

  let%lwt () = Serfrpc.Io.stream ~seq:50 ~callback:cb ~type2:"user:deploy" oc in

  let%lwt () = Lwt_unix.sleep 50000.0 in

  Lwt_io.close ic

let _ = Lwt_main.run test
