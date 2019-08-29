-module(mad_ca).
-include_lib("public_key/include/public_key.hrl").
-compile(export_all).

host()         -> "ca.n2o.dev:8046".
cat(X)         -> lists:concat(X).
replace(S,A,B) -> re:replace(S,A,B,[global,{return,binary}]).
u(X)           -> string:to_upper(X).
root(Crypto)   -> {cat(["cert/",Crypto,"/"]),"synrc.cnf"}.

rsa(X)         -> cmd("rsa",X).
ecc(X)         -> cmd("ecc",X).

cmd(C,[])      -> boot(C), {ok,C};
cmd(C,["ca"])  -> boot(C), up(C), {ok,C};
cmd(C,[T|N])   -> boot(C), enroll(C,T,N), {ok,C};
cmd(C,_)       -> boot(C), {ok,C}.

boot(Crypto) ->
    {Dir,CNF} = root(Crypto),
    case file:read_file_info(Dir++CNF) of
         {ok,_} -> skip;
         {error,_} -> {Dir,CNF} = root(Crypto), filelib:ensure_dir(Dir),
                      file:write_file(Dir++CNF,replace(replace(cnf(),"PATH",mad_utils:cwd()),"CRYPTO",Crypto)),
                      up(Crypto) end, {ok,Crypto}.

up(Crypto) ->
    application:start(inets),
    URI = cat(["http://",host(),"/up/",Crypto]),
    {ok,{{"HTTP/1.1",200,"OK"},_,Cert}} = httpc:request(post,{URI,[],[],<<"">>},[],[]),
    PEM = list_to_binary(Cert),
    ok  = file:write_file(cat(["cert/",Crypto,"/caroot.pem"]),PEM),
    dump(PEM,"CA").

enroll(Crypto,Type,Name) when (Type == "server" orelse Type == "client")
                      andalso (Crypto == "rsa" orelse Crypto == "ecc") ->
    Pass = application:get_env(ca,passin,"pass:0"),
    application:start(inets),
    X   = string:join(Name,"\\ "),
    Y   = string:join(Name," "),
    ok  = key(Crypto,Pass,Y),
    {ok, F} = file:read_file(cat(["cert/",Crypto,"/",Y,".csr"])),
    URI = cat(["http://",host(),"/enroll/",Crypto,"/",Type]),
    {ok,{{"HTTP/1.1",200,"OK"},_,Cert}} = httpc:request(post,{URI,[],"multipart/form-data",F},[],[]),
    PEM = list_to_binary(Cert),
    ok  = file:write_file(cat(["cert/",Crypto,"/",Y,".pem"]),PEM),
    dump(PEM,Y).

dump(PEM,Y) ->
    {_,{_,D,_}} = lists:keysearch('Certificate',1,public_key:pem_decode(PEM)),
    OTPCert = public_key:pkix_decode_cert(D,otp),
    PKIInfo = OTPCert#'OTPCertificate'.tbsCertificate#'OTPTBSCertificate'.subjectPublicKeyInfo,
    io:format("CERT: ~s KEY: ~p~n",[Y,PKIInfo]).

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
