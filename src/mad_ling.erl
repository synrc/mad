-module(mad_ling).
-description("LING Erlang Virtual Machine Bundle Packaging").
-copyright('Cloudozer, LLP').
-compile(export_all).

main(App) ->
    io:format("Bundle Name: ~p~n",[mad_repl:local_app()]),
    io:format("System: ~p~n",     [mad_repl:system()]),
    io:format("Apps: ~p~n",       [mad_repl:applist()]),
    io:format("Overlay: ~p~n",    [overlay()]),
    io:format("Files: ~p~n",      [[B||{B,_} <- bundle()]]),
    add_apps(),
    false.

bundle()         -> mad_bundle:beams(fun filename:basename/1) ++ mad_bundle:privs().
cache_dir()      -> ".railing".
overlay()        -> filelib:wildcard("deps/ling/apps/*/ebin/*.beam").
local_map(Bucks) -> list_to_binary(lists:map(fun({B,M,_}) ->
                    io_lib:format("~s /~s\n",[M,B]) end, Bucks)).

bundle_name() ->
    case file:get_cwd() of
         {ok,"/"} -> "himmel";
         {ok,Cwd} -> filename:basename(Cwd) end.

add_apps() ->
    StartBoot = lists:concat([code:root_dir(),"/bin/start.boot"]),
    Bucks     = [ {boot, "/boot", [local_map, StartBoot]} ]
             ++ [ lib(A) || A <- mad_repl:applist() ].

lib(A) -> A.

embed_fs(Bucks)  ->
    EmbedFsPath   = lists:concat([cache_dir(),"/embed.fs"]),
    {ok, EmbedFs} = file:open(EmbedFsPath, [write]),
    BuckCount = length(Bucks),
    BinCount = lists:foldl(fun({_,_,Bins},Count) -> Count + length(Bins) end,0,Bucks),
    file:write(EmbedFs, <<BuckCount:32,BinCount:32>>),
    lists:foreach(fun({Buck,_,Bins}) ->
		  BuckName = binary:list_to_bin(atom_to_list(Buck)),
          BuckNameSize = size(BuckName),
		  BuckBinCount = length(Bins),
          file:write(EmbedFs, <<BuckNameSize, BuckName/binary, BuckBinCount:32>>),
          lists:foreach(fun
                (local_map) -> write_bin(EmbedFs, "local.map", local_map(Bucks));
                (Bin) -> write_bin(EmbedFs, filename:basename(Bin), element(2,file:read_file(Bin)))
          end,Bins)
    end,Bucks),
    file:close(EmbedFs).

write_bin(Dev, Bin, Data) ->
    Name = binary:list_to_bin(Bin),
    NameSize = size(Name),
    DataSize = size(Data),
    file:write(Dev, <<NameSize, Name/binary, DataSize:32, Data/binary>>).
