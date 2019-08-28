-module(mad_ca).
-include_lib("public_key/include/public_key.hrl").
-copyright("SYNRC Certificate Authority").
-compile(export_all).

write(Gen,Bin) -> io:format("Generated: ~p~n",[Gen]), file:write_file(Gen,Bin).
replace(S,A,B) -> re:replace(S,A,B,[global,{return,list}]).
u(X) -> string:to_upper(X).

boot(Crypto) ->
   Temp    = template(),
   Tem2    = replace(Temp,"PATH", mad_utils:cwd()),
   Bin     = iolist_to_binary(replace(Tem2,"CRYPTO",Crypto)),
   Gen     = lists:concat(["cert/",Crypto,"/synrc.cnf"]),
   Index   = lists:concat(["cert/",Crypto,"/index.txt"]),
   CRL     = lists:concat(["cert/",Crypto,"/crlnumber"]),
   Serial  = lists:concat(["cert/",Crypto,"/serial"]),
   Counter = <<"1000">>,
   case file:read_file_info(Gen) of
         {error,_} ->
             filelib:ensure_dir(Gen),
             lists:map(fun({A,B}) -> file:write_file(A,B) end,
                [{Index,<<>>},{CRL,Counter},{Serial,Counter},{Gen,Bin}]),
             ca(Crypto);
         {ok,_} -> skip end,
   {ok,man}.

subj() -> io:format("Subject not specified.").

rsa(["ca"]) -> boot("rsa"), ca("rsa"), {ok,rsa};
rsa([Type|Name]) ->  boot("rsa"), enroll("rsa",Type,Name);
rsa(_) -> boot("rsa").

ecc(["ca"]) -> boot("ecc"), ca("ecc"), {ok,ecc};
ecc([Type|Name]) ->  boot("ecc"), enroll("ecc",Type,Name);
ecc(_) -> boot("ecc").


ca("rsa") ->
  {done,0,Bin}  = sh:run("openssl genrsa -out cert/rsa/caroot.key 2048"),
  {done,0,Bin2} = sh:run("openssl req -new -x509 -days 3650 -config cert/rsa/synrc.cnf"
                         " -key cert/rsa/caroot.key -out cert/rsa/caroot.pem"
                         " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\"");
ca("ecc") ->
  Pass = application:get_env(ca,passin,"pass:0"),
  {done,0,Bin} = sh:run("openssl ecparam -genkey -name secp384r1"),
  file:write_file("cert/ecc/ca.key",Bin),
  {done,0,Bin2} = sh:run("openssl ec -aes256 -in cert/ecc/ca.key"
                         " -out cert/ecc/caroot.key -passout " ++ Pass),
  {done,0,Bin3} = sh:run("openssl req -config cert/ecc/synrc.cnf -days 3650 -new -x509"
                         " -key cert/ecc/caroot.key -out cert/ecc/caroot.pem -passin " ++ Pass ++
                         " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\""),
  ok.

enroll(Crypto,Type,Name) when (Type == "server" orelse Type == "client")
                      andalso (Crypto == "rsa" orelse Crypto == "ecc") ->
  Pass = application:get_env(ca,passin,"pass:0"),
  application:start(inets),
  X = string:join(Name,"\\ "),
  Y = string:join(Name," "),
  key(Crypto,Pass,X),
  {ok, F} = file:read_file("cert/"++Crypto++"/"++Y++".csr"),
  {ok,{{"HTTP/1.1",200,"OK"},_,Cert}}
    = httpc:request(post,{"http://ca.n2o.dev:8046/"++Crypto++"/"++Type,
                       [],"multipart/form-data",F},[],[]),
  DER = list_to_binary(Cert),
  file:write_file("cert/"++Crypto++"/"++Y++".pem",DER),
  Entries = public_key:pem_decode(DER),
  {value, CertEntry} = lists:keysearch('Certificate', 1, Entries),
  {_, DerCert, _} = CertEntry,
  Decoded = public_key:pkix_decode_cert(DerCert, otp),
  PK = Decoded#'OTPCertificate'.tbsCertificate#'OTPTBSCertificate'.subjectPublicKeyInfo,
  io:format("CERT: ~s ~s '~s'~nKEY: ~p~n",[u(Crypto),u(Type),X,PK]),
  {ok,rsa}.


key("rsa",_,X) ->
  {done,0,Bin}  = sh:run("openssl genrsa -out cert/rsa/"++ X ++ ".key 2048"),
  {done,0,Bin2} = sh:run("openssl req -new -days 365 -key cert/rsa/"++ X ++".key"
                         " -out cert/rsa/"++ X ++".csr "
                         " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN="++ X ++ "\""), ok;
key("ecc",Pass,X) ->
  Pass = application:get_env(ca,passin,"pass:0"),
  {done,0,_}   = sh:run("openssl ecparam -name secp384r1 > cert/ecc/"++X++".ecp"),
  {done,0,_}   = sh:run("cp cert/ecc/"++X++".ecp key"),
  {done,0,Bin} = sh:run("openssl req -config cert/ecc/synrc.cnf -passout " ++ Pass ++
                        " -new -newkey ec:key"
                        " -keyout cert/ecc/"++X++".key.enc -out cert/ecc/"++X++".csr"
                        " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN="++X++"\""),
  {done,0,Bin2} = sh:run("openssl ec -in cert/ecc/"++X++".key.enc -out cert/ecc/server.key -passin "++Pass),
  ok.

template() ->
    mad_repl:load(),
    try lists:flatten(
        [case string:str(File,"priv/cnf") of 1 -> Bin; _ -> []
          end || {File,Bin} <- ets:tab2list(filesystem), is_list(File)])
        catch _:_ -> [] end.
