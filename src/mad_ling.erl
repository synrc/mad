-module(mad_ling).
-description("LING Erlang Virtual Machine Bundle Packaging").
-copyright('Cloudozer, LLP').
-compile(export_all).
-define(ARCH, list_to_atom( case os:getenv("ARCH") of false -> "posix_x86"; A -> A end)).

main(App) ->
    io:format("Bundle Name: ~p~n",[mad_repl:local_app()]),
    io:format("System: ~p~n",     [mad_repl:system()]),
    io:format("Apps: ~p~n",       [mad_repl:applist()]),
    io:format("Overlay: ~p~n",    [[{filename:basename(N),size(B)}||{N,B}<-mad_bundle:overlay()]]),
    io:format("Files: ~p~n",      [[B||{B,_} <- bundle()]]),
    add_apps(),
    false.

cache_dir()       -> ".railing".
local_map(Bucks)  -> list_to_binary(lists:map(fun({B,M,_}) -> io_lib:format("~s /~s\n",[M,B]) end,Bucks)).
bundle()          -> lists:flatten([ mad_bundle:X() || X <- [beams,privs,system_files,overlay] ]).
library(Filename) -> case filename:split(Filename) of
    ["deps","ling","apps",Lib|_] -> list_to_atom(Lib);
                      ["ebin"|_] -> mad_repl:local_app();
                      ["priv"|_] -> mad_repl:local_app();
           A when length(A) >= 3 -> list_to_atom(hd(string:tokens(lists:nth(3,lists:reverse(A)),"-")));
                  ["apps",Lib|_] -> list_to_atom(Lib);
                  ["deps",Lib|_] -> list_to_atom(Lib);
                               _ -> mad_repl:local_app() end.

apps(Ordered) ->
    Overlay = [{filename:basename(N),B}||{N,B}<-mad_bundle:overlay()],
    lists:foldl(fun({N,B},Acc) ->
        A = library(N),
        Base = filename:basename(N),
        Body = case lists:keyfind(Base,1,Overlay) of
                    false -> B;
                    {Base,Bin} -> io:format("Overlay: ~p~n",[{A,Base}]), Bin end,
         case lists:keyfind(A,1,Acc) of
              false -> [{A,[{A,Base,Body}]}|Acc];
              {A,Files} -> lists:keyreplace(A,1,Acc,{A,[{A,Base,Body}|Files]}) end
    end,lists:zip(Ordered,lists:duplicate(length(Ordered),[])),bundle()).

boot(Ordered) ->
    {script,Erlang,List} = binary_to_term(element(2,file:read_file(lists:concat([code:root_dir(),"/bin/start.boot"])))),
    Boot = [ L || L<-List, element(1,L) /= 'apply', L/={'progress',started} ]
        ++ [{'apply',{application,start_boot,[A,permanent]}} || A <- Ordered ]
        ++ [{'progress',synrc}],
    io:format("Boot File: ~p~n",[Boot]),
    {[],"start.boot",term_to_binary({script,Erlang,List})}.

erlang_lib({App,Files}) -> {App,lists:concat(["/erlang/lib/",App,"/ebin"]),Files}.

add_apps() ->
    {ok,Ordered} = mad_plan:orderapps(),
    Bucks     = [ {boot, "/boot", [local_map, boot(Ordered)]} ] ++
                [ erlang_lib(E) || E <- apps(Ordered) ],
    io:format("Bucks: ~p~n",[[{App,Mount,[{filename:basename(F),size(Bin)}||{_,F,Bin}<-Files]}||{App,Mount,Files}<-Bucks]]),
    EmbedFsPath   = lists:concat([cache_dir(),"/embed.fs"]),
    io:format("Initializing GooFS: ..."),
    Res = embed_fs(EmbedFsPath,Bucks),
    io:format("~p~n",[Res]),
	{ok, EmbedFsObject} = embedfs_object(EmbedFsPath),
	Res = case sh:oneliner(ld() ++
	           ["vmling.o", EmbedFsObject, "-o", "../" ++ atom_to_list(mad_repl:local_app()) ++ ".img"],
	           cache_dir()) of
	           {_,0,_} -> ok;
	           {_,_,M} -> binary_to_list(M) end,
    io:format("Linking Image: ~p~n",[Res]).

embed_fs(EmbedFsPath,Bucks)  ->
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
                    (local_map) -> write_bin(EmbedFs, [], "local.map", local_map(Bucks));
                  ({App,F,Bin}) -> write_bin(EmbedFs, App, filename:basename(F), Bin)
          end,Bins)
    end,Bucks),
    file:close(EmbedFs).

embedfs_object(EmbedFsPath) ->
	EmbedCPath = filename:join(filename:absname(cache_dir()), "embedfs.c"),
	OutPath = filename:join(filename:absname(cache_dir()), "embedfs.o"),
	{ok, Embed} = file:read_file(EmbedFsPath),
	io:format("Creating GooFS C file: ..."),
	Res = bfd_objcopy:blob_to_src(EmbedCPath, "_binary_embed_fs", Embed),
    io:format("~p~n",[Res]),
	io:format("Compilation of Filesystem object: ..."),
	Res = case sh:oneliner(cc() ++ ["-o", OutPath, "-c", EmbedCPath]) of
	           {_,0,_} -> ok;
	           {_,_,M} -> binary_to_list(M) end,
	io:format("~p~n",[Res]),
	{ok, OutPath}.

write_bin(Dev, App, F, Bin) ->
    Name = binary:list_to_bin(F),
    Data = case filename:extension(F) of ".beam" -> beam_to_ling(Bin); _ -> Bin end,
    NameSize = size(Name),
    DataSize = size(Data),
    file:write(Dev, <<NameSize, Name/binary, DataSize:32, Data/binary>>).

beam_to_ling(B) ->
    ling_lib:specs_to_binary(element(2,ling_code:ling_to_specs(element(2,ling_code:beam_to_ling(B))))).

gold() -> gold("ld").
gold(Prog) -> [Prog, "-T", "ling.lds", "-nostdlib"].

ld() -> ld(?ARCH).
ld(arm) -> gold("arm-none-eabi-ld");
ld(xen_x86) -> case os:type() of {unix, darwin} -> ["x86_64-pc-linux-ld"]; _ -> gold() end;
ld(posix_x86) -> case os:type() of {unix, darwin} ->
    ["ld","-image_base","0x8000","-pagezero_size","0x8000","-arch","x86_64","-framework","System"];
	_ -> gold() end;
ld(_) -> gold().

cc() -> cc(?ARCH).
cc(arm) -> ["arm-none-eabi-gcc", "-mfpu=vfp", "-mfloat-abi=hard"];
cc(xen_x86) -> case os:type() of {unix, darwin} -> ["x86_64-pc-linux-gcc"]; _ -> ["cc"] end;
cc(_) -> ["cc"].

