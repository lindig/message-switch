
let config_mk = "config.mk"

(* Configure script *)
open Cmdliner

let bindir =
  let doc = "Set the directory for installing binaries" in
  Arg.(value & opt string "/usr/bin" & info ["bindir"] ~docv:"BINDIR" ~doc)

let info =
  let doc = "Configures a package" in
  Term.info "configure" ~version:"0.1" ~doc 

let output_file filename lines =
  let oc = open_out filename in
  let lines = List.map (fun line -> line ^ "\n") lines in
  List.iter (output_string oc) lines;
  close_out oc

let configure bindir =
  Printf.printf "Configuring with:\n\tbindir=%s\n\n" bindir;

  (* Write config.mk *)
  let lines = 
    [ "# Warning - this file is autogenerated by the configure script";
      "# Do not edit";
      Printf.sprintf "BINDIR=%s" bindir;
    ] in
  output_file config_mk lines

let configure_t = Term.(pure configure $ bindir)

let () = 
  match 
    Term.eval (configure_t, info) 
  with
  | `Error _ -> exit 1 
  | _ -> exit 0