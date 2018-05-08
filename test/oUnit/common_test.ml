open OUnit

let suite =
  "Common" >::: [
    "Address_to_string" >:: (fun _ ->
      let address = [127;0;0;1] in
      let string_of_address = Serfrpc.Common.Address.to_string address in

      assert_equal string_of_address "127.0.0.1"
    );
  ]

let run_common_tests = run_test_tt_main suite
