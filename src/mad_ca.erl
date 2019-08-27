-module(mad_ca).
-copyright("SYNRC Certificate Authority").
-compile(export_all).

write(Gen,Bin) -> io:format("Generated: ~p~n",[Gen]), file:write_file(Gen,Bin).
replace(S,A,B) -> re:replace(S,A,B,[global,{return,list}]).

boot(Crypto) ->
   Temp    = template(),
   Tem2    = replace(Temp,"PATH", mad_utils:cwd()),
   Bin     = iolist_to_binary(replace(Tem2,"CRYPTO",Crypto)),
   Gen     = lists:concat(["cert/",Crypto,"/synrc.cnf"]),
   Index   = lists:concat(["cert/",Crypto,"/index.txt"]),
   CRL     = lists:concat(["cert/",Crypto,"/crlnumber"]),
   Serial  = lists:concat(["cert/",Crypto,"/serial"]),
   Counter = <<"1000">>,
   filelib:ensure_dir(Gen),
   file:write_file(Index,<<>>),
   file:write_file(CRL,Counter),
   file:write_file(Serial,Counter),
   case file:read_file_info(Gen) of
         {error,_} -> write(Gen, Bin);
         {ok,_} -> io:format("~s: file ~p already exists.~n",[Crypto,Gen]) end,
   {ok,man}.

subj() -> io:format("Subject not specified.").

rsa(["client"|Name]) ->
  application:start(inets),
  X = string:join(Name,"\\ "),
  Y = string:join(Name," "),
  {done,0,Bin}  = sh:run("openssl genrsa -out cert/rsa/"++ X ++ ".key 2048"),
  {done,0,Bin2} = sh:run("openssl req -new -days 365 -key cert/rsa/"++ X ++".key"
                         " -out cert/rsa/"++ X ++".csr"
                         " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN="++ X ++ "\""),
  {ok, F} = file:read_file("cert/rsa/"++Y++".csr"),
  {ok,{{"HTTP/1.1",200,"OK"},_,Cert}}
    = httpc:request(post,{"http://ca.n2o.dev:8046/rsa/client",[],"multipart/form-data",F},[],[]),
  file:write_file("cert/rsa/"++Y++".pem",list_to_binary(Cert)),
  {ok,rsa};

rsa(["ca"]) ->
  boot("rsa"),
  {done,0,Bin}  = sh:run("openssl genrsa -out cert/rsa/caroot.key 2048"),
  {done,0,Bin2} = sh:run("openssl req -new -x509 -days 3650 -config cert/rsa/synrc.cnf"
                         " -key cert/rsa/caroot.key -out cert/rsa/caroot.pem"
                         " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\""),
  {ok,rsa};

rsa(["new"]) -> boot("rsa");
rsa(_) -> boot("rsa").

ecc(["ca"|Pass]) ->
  boot("ecc"),
  {done,0,Bin} = sh:run("openssl ecparam -genkey -name secp384r1"),
  file:write_file("cert/ecc/ca.key",Bin),
  {done,0,Bin2} = sh:run("openssl ec -aes256 -in cert/ecc/ca.key"
                         " -out cert/ecc/caroot.key -passout " ++ Pass),
  {done,0,Bin3} = sh:run("openssl req -config cert/ecc/synrc.cnf -days 3650 -new -x509"
                         " -key cert/ecc/caroot.key -out cert/ecc/caroot.pem -passin " ++ Pass ++
                         " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\""),
  {ok,ecc};
ecc(_) -> boot("ecc").

template() ->
    mad_repl:load(),
    try lists:flatten(
        [case string:str(File,"priv/cnf") of 1 -> Bin; _ -> []
          end || {File,Bin} <- ets:tab2list(filesystem), is_list(File)])
        catch _:_ -> [] end.
