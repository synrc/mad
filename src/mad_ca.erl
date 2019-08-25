-module(mad_ca).
-compile(export_all).

write(Gen,Bin) -> io:format("Generated: ~p~n",[Gen]), file:write_file(Gen,Bin).
replace(S,A,B) -> re:replace(S,A,B,[global,{return,list}]).

boot(Crypto) ->
   Temp = template(),
   Tem2 = replace(Temp,"PATH", mad_utils:cwd()),
   Bin = iolist_to_binary(replace(Tem2,"CRYPTO",Crypto)),
   Gen = lists:concat(["cert/",Crypto,"/synrc.cnf"]),
   filelib:ensure_dir(Gen),
   case file:read_file_info(Gen) of
         {error,_} -> write(Gen, Bin);
         {ok,_} -> io:format("~s: file ~p already exists.~n",[Crypto,Gen]) end,
   {ok,man}.

subj() -> io:format("Subject not specified.").

rsa(["client","key"]) -> sh:run("openssl genrsa -out cert/rsa/client.key 2048"), {ok,rsa};
rsa(["ca"]) -> boot("rsa"), sh:run("openssl genrsa -out cert/rsa/caroot.key 2048"),
               sh:run("openssl req -new -x509 -days 3650 -config cert/rsa/synrc.cnf "
                      "-key cert/rsa/caroot.key "
                      "-out cert/rsa/caroot.pem "
                      "-subj \"/C=UA/ST=Kyiv/O=SYNRC/CN=CA\""), {ok,rsa};
rsa(["new"]) -> boot("ecc");
rsa(_) -> boot("rsa").

ecc(_) -> boot("ecc").

template() ->
    mad_repl:load(),
    try lists:flatten(
        [case string:str(File,"priv/cnf") of 1 -> Bin; _ -> []
          end || {File,Bin} <- ets:tab2list(filesystem), is_list(File)])
        catch _:_ -> [] end.
