-module(mad_ez).
-description("EZ bundle").
-compile(export_all).
%cd path/to/app; mad ez
main(_) -> 
  mad_resolve:main([]),
  Base = filename:basename(mad_utils:cwd()),
  [AppFile] = mad_repl:wildcards(["ebin/*.app"]),
  Vsn = vsn(AppFile),
  {Name,App} = case lists:suffix("-" ++ Vsn,Base) of
                true  -> {Base,Base -- ["-"++Vsn]};
                false -> {Base++"-"++Vsn,Base}
               end,
  Rename = fun(F)-> 
             Path = filename:join([Name, "ebin", filename:basename(F)]),
             mad:info("Ez ~s~n",[Path]),
             Path
           end,
  Files = static() ++ beams(Rename,fun read/1),
  {ok,_}= zip:create(Name ++ ".ez", Files, opts()),
  {ok,App}. 

opts() -> [{compress,all},{uncompress,[".beam",".app",".so"]}].
read(F)-> {ok, B} = file:read_file(filename:absname(F)), B.
vsn(F) -> case file:consult( F ) of
            { ok, [{application,_,Terms}|_]} -> 
              proplists:get_value(vsn, Terms, []);
            _ -> []
          end.
id(X) -> X.

static() ->
  Name = "static.gz",
  {ok,{_,Bin}} = zip:create(Name,
      [ begin
           mad:info("static: ~ts~n",[F]),
           { binary_to_list(base64:encode(unicode:characters_to_binary(F))), element(2,file:read_file(F)) }
        end 
   || F <- mad_repl:wildcards(["priv/**"]), not filelib:is_dir(F) ],
      [{compress,all},memory]),
  [ { Name, Bin } ].

beams() -> beams(fun id/1,  fun read/1).
beams(Fun,Read) ->
  [ { Fun(F), Read(F) } ||
      F <- mad_repl:wildcards(["ebin/*","sys.config",".applist"]) ].

privs() -> privs(fun id/1,  fun read/1).
privs(Fun,Read) ->
  [ { Fun(F), Read(F) } ||
      F <- mad_repl:wildcards(["priv/**"]), not filelib:is_dir(p(F)) ].

p(F) -> mad:info("~p~n",[F]),F.
