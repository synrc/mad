-module(mad_man).
-doc("Generate n2o.dev man pages.").
-compile(export_all).

man(Params) ->
   Temp = template(),
   [ generate(filename:basename(I,".erl"),Temp)
    || I <- filelib:wildcard("*/src/**/*.erl")
         ++ filelib:wildcard("src/**/*.erl") ],
   false.

replace(S,A,B) -> re:replace(S,A,B,[global,{return,list}]).
fix([Prefix]) -> Prefix;
fix([Prefix,Name|Rest]) -> Name.
generate(Lower,Temp) ->
    Name = string:to_upper(Lower),
    Bin = iolist_to_binary(replace(Temp,"MAN_NAME",fix(string:tokens(Name,"_")))),
    Gen = lists:concat(["man/",Lower,".htm"]),
    case file:read_file_info(Gen) of
         {error,_} -> io:format("Generated: ~p~n",[Gen]), file:write_file(Gen, Bin);
         {ok,A} -> case element(2,A) > size(Bin) of
                        true -> skip;
                        false -> warning end end.

template() ->
    mad_repl:load(),
    try lists:flatten(
        [case string:str(File,"priv/man") of 1 -> Bin; _ -> []
          end || {File,Bin} <- ets:tab2list(filesystem), is_list(File)])
        catch _:_ -> [] end.
