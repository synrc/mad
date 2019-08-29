-module(mad_ca).
-include_lib("public_key/include/public_key.hrl").
-compile(export_all).

cat(X)         -> lists:concat(X).
replace(S,A,B) -> re:replace(S,A,B,[global,{return,binary}]).
u(X)           -> string:to_upper(X).
root(Crypto)   -> {cat(["cert/",Crypto,"/"]),"synrc.cnf"}.

rsa(X)         -> cmd("rsa",X).
ecc(X)         -> cmd("ecc",X).

cmd(C,[])      -> {ok, C};
cmd(C,["ca"])  -> boot(C), ca(C), {ok,C};
cmd(C,[T|N])   -> boot(C), enroll(C,T,N), {ok,C};
cmd(C,_)       -> boot(C), {ok,C}.

boot(Crypto) ->
    {Dir,CNF} = root(Crypto),
    case file:read_file_info(Dir++CNF) of
        {error,_} -> do_boot(Crypto);
        {ok,_} -> skip end, {ok,Crypto}.

do_boot(Crypto) ->
    {Num,Bin} = {<<"1000">>,replace(replace(cnf(),"PATH",mad_utils:cwd()),"CRYPTO",Crypto)},
    {Dir,CNF} = root(Crypto), filelib:ensure_dir(Dir),
    Files     = [{"index.txt",<<>>},{"crlnumber",Num},{"serial",Num},{CNF,Bin}],
    lists:map(fun({A,B}) -> file:write_file(Dir++A,B) end, Files), ca(Crypto).

ca("rsa") ->
    {done,0,_} = sh:run("openssl genrsa -out cert/rsa/caroot.key 2048"),
    {done,0,_} = sh:run("openssl req -new -x509 -days 3650 -config cert/rsa/synrc.cnf"
       " -key cert/rsa/caroot.key -out cert/rsa/caroot.pem"
       " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\"");

ca("ecc") ->
    Pass = application:get_env(ca,passin,"pass:0"),
    {done,0,_} = sh:run("openssl ecparam -genkey -name secp384r1 -out cert/ecc/ca.key"),
    {done,0,_} = sh:run("openssl ec -aes256 -in cert/ecc/ca.key -out cert/ecc/caroot.key -passout " ++ Pass),
    {done,0,_} = sh:run("openssl req -config cert/ecc/synrc.cnf -days 3650 -new -x509"
        " -key cert/ecc/caroot.key -out cert/ecc/caroot.pem -passin " ++ Pass ++
        " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\"").

enroll(Crypto,Type,Name) when (Type == "server" orelse Type == "client")
                      andalso (Crypto == "rsa" orelse Crypto == "ecc") ->
    Pass = application:get_env(ca,passin,"pass:0"),
    application:start(inets),
    X   = string:join(Name,"\\ "),
    Y   = string:join(Name," "),
    ok  = key(Crypto,Pass,Y),
    {ok, F} = file:read_file(cat(["cert/",Crypto,"/",Y,".csr"])),
    URI = cat(["http://ca.n2o.dev:8046/",Crypto,"/",Type]),
    {ok,{{"HTTP/1.1",200,"OK"},_,Cert}} = httpc:request(post,{URI,[],"multipart/form-data",F},[],[]),
    PEM = list_to_binary(Cert),
    ok  = file:write_file(cat(["cert/",Crypto,"/",Y,".pem"]),PEM),
    {_,{_,D,_}} = lists:keysearch('Certificate',1,public_key:pem_decode(PEM)),
    OTPCert = public_key:pkix_decode_cert(D,otp),
    PKIInfo = OTPCert#'OTPCertificate'.tbsCertificate#'OTPTBSCertificate'.subjectPublicKeyInfo,
    io:format("CERT: ~s ~s '~s'~nKEY: ~p~n",[u(Crypto),u(Type),Y,PKIInfo]).

key("rsa",_,X) ->
    {done,0,Bin}  = sh:run("openssl genrsa -out \"cert/rsa/"++ X ++ ".key\" 2048"),
    {done,0,Bin2} = sh:run("openssl req -new -days 365 -key \"cert/rsa/"++ X ++".key\" -out \"cert/rsa/"++ X ++".csr\" "
        " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN="++ X ++ "\""), ok;

key("ecc",Pass,X) ->
    Pass = application:get_env(ca,passin,"pass:0"),
    {done,0,_}   = sh:run("openssl ecparam -name secp384r1 -out \"cert/ecc/"++X++".ecp\""),
    {done,0,_}   = sh:run("cp \"cert/ecc/"++X++".ecp\" key"),
    {done,0,Bin} = sh:run("openssl req -config cert/ecc/synrc.cnf -passout " ++ Pass ++
        " -new -newkey ec:key -keyout \"cert/ecc/"++X++".key.enc\" -out \"cert/ecc/"++X++".csr\""
        " -subj \"/C=UA/ST=Kyiv/O=SYNRC/CN="++X++"\""),
    {done,0,_}    = sh:run("rm key"),
    {done,0,Bin2} = sh:run("openssl ec -in \"cert/ecc/"++X++".key.enc\" -out \"cert/ecc/"++X++".key\" -passin "++Pass),
    ok.

cnf() ->
    mad_repl:load(),
    try lists:flatten(
        [case string:str(File,"priv/cnf") of 1 -> Bin; _ -> []
          end || {File,Bin} <- ets:tab2list(filesystem), is_list(File)])
        catch _:_ -> [] end.
