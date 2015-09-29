-module(mad_systools).
-description("ERTS releases with systools").
-compile(export_all).

% beam releases

scripts(N) ->
    mad_repl:load(),
    {ok,Bin} = mad_repl:load_file("priv/systools/start"),
    [{"/bin/start",list_to_binary(re:replace(binary_to_list(Bin),"{release}",N,[global,{return,list}]))},
     {"/bin/attach",element(2,mad_repl:load_file("priv/systools/attach"))},
     {"/bin/daemon",element(2,mad_repl:load_file("priv/systools/daemon"))},
     {"/etc/"++N++".boot",N++".boot"},
     {"/etc/vm.args","vm.args"},
     {"/etc/sys.config","sys.config"}].

apps(List) ->
    lists:flatten([[[ {filename:join([lib,
        lists:concat([App,"-",Version]),Class,filename:basename(F)]),F}
    || F <- mad_repl:wildcards([filename:join([Dir,Class,"*"])]) ]
    || {App,{Version,Dir}} <- List ] || Class <- [ebin,priv] ]).

release(Name) ->
    Triples = mad_resolve:triples(),
    Apps = lists:usort(fun({Name,_},{Name2,_})-> Name =< Name2 end,
                [{A,{B,F}}||{_,A,{B,F}}<-Triples]) ++
      [{kernel,{proplists:get_value(vsn,element(2,
                application:get_all_key(kernel)),[]),
                filename:absname(code:lib_dir(kernel))}}],
    Sorted = [ lists:keyfind(A,1,Apps) || A <- element(2,mad_resolve:orderapps())],
    {L,R}     = lists:unzip(Sorted),
    {Ver,Dir} = lists:unzip(R),
    NameVer   = [ X || X <- lists:zip(L,Ver), element(1,X) /= active,
                                              element(1,X) /= fs ],
    Version = case lists:keyfind(list_to_atom(Name),2,Triples) of
                  {_,_,{Vsn,_}} -> Vsn;
                  _ -> "1" end,
    {{release,{Name,Version},{erts,erlang:system_info(version)},NameVer},Sorted}.

beam_release(N) ->
    mad_resolve:main([]),
    Directories = mad_repl:wildcards(["{deps,apps}/*/ebin","ebin"]),
    code:add_paths(Directories),
    {Release,Apps} = release(N),
    file:write_file(N ++ ".rel",io_lib:format("~p.",[Release])),
    Res = systools:make_script(N),
    systools:make_tar(N),
    Files = [ {"/bin/" ++ filename:basename(F), F}
        || F <- mad_repl:wildcards([code:root_dir() ++
            "/erts-" ++ erlang:system_info(version) ++
            "/bin/{epmd,erlexec,run_erl,to_erl,escript,beam.smp}"]) ] ++
        apps(Apps) ++ scripts(N),
    erl_tar:create(N ++ ".tgz",Files,[compressed]),
    mad:info("~s.boot: ~p~n",[N,Res]),
    {ok,N}.
