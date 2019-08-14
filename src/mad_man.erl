-module(mad_man).
-doc("Generate n2o.dev man pages.").
-compile(export_all).

man(["html"]) ->
   Temp = template(),
   [ generate(filename:basename(I,".erl"),Temp)
    || I <- filelib:wildcard("*/src/**/*.erl")
         ++ filelib:wildcard("src/**/*.erl") ],
   {ok,man};

man(["groff"]) ->
   case lists:all(fun(X) -> mad_groff:do(X) == ok end,
        filelib:wildcard("man/**/*.htm")
     ++ filelib:wildcard("articles/**/*.htm")
     ++ filelib:wildcard("*.html")
     ++ filelib:wildcard("*.htm")) of
        true -> {ok,check};
        false -> {error,check} end;

man(["check"]) ->
   case lists:all(fun(X) -> element(1,X) == ok end, [ check(I)
    || I <- filelib:wildcard("*.htm")
         ++ filelib:wildcard("*.html")
         ++ filelib:wildcard("man/**/*.htm")
         ++ filelib:wildcard("articles/**/*.htm") ]) of
        true -> {ok,check};
        false -> {error,check} end.

write(Gen,Bin) -> io:format("Generated: ~p~n",[Gen]), file:write_file(Gen,Bin).
replace(S,A,B) -> re:replace(S,A,B,[global,{return,list}]).
trim(A) when is_list(A) -> trim(unicode:characters_to_binary(A));
trim(A) when is_binary(A) -> re:replace(A, "(^\\s+)|(\\s+$)", "", [global,{return,list}]).
fix([Prefix]) -> Prefix;
fix([_Prefix,Name|_Rest]) -> Name.
check(Filename) ->
   try _ = xmerl_scan:file(Filename), {ok,Filename} catch E:R ->
   io:format("man: ~p error: ~p~n",[Filename,{E,R}]), {error,Filename} end.

generate(Lower,Temp) ->
    Name = string:to_upper(Lower),
    Tem2 = replace(Temp,"MAN_TOOL",hd(string:tokens(Name,"_"))),
    CNAME = binary_to_list(element(2,file:read_file("CNAME"))),
    Tem3 = replace(Tem2,"MAN_CNAME",trim(CNAME)),
    Bin = iolist_to_binary(replace(Tem3,"MAN_NAME",fix(string:tokens(Name,"_")))),
    Gen = lists:concat(["man/",Lower,".htm"]),
    case file:read_file_info(Gen) of
         {error,_} -> write(Gen, Bin);
         {ok,_} -> io:format("man: file ~p already exists.~n",[Gen])
                  % case element(2,A) > size(Bin) of
                  %      true -> skip;
                  %      false -> write(Gen,Bin) end
                  end.

template() ->
    mad_repl:load(),
    try lists:flatten(
        [case string:str(File,"priv/man") of 1 -> Bin; _ -> []
          end || {File,Bin} <- ets:tab2list(filesystem), is_list(File)])
        catch _:_ -> [] end.
