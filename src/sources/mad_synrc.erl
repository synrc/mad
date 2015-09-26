-module(mad_synrc).
-compile(export_all).

deps(Params) ->
    { Cwd, ConfigFile, Conf } = mad_utils:configs(),
    case mad_utils:get_value(deps, Conf, []) of
        [] -> {ok,[]};
        Deps -> file:make_dir(mad_utils:get_value(deps_dir, Conf, ["deps"])),
                (mad:profile()):fetch([Cwd, Conf, ConfigFile, Deps]) end.

contains(X,String,Acc) ->
    case string:str(String,atom_to_list(X)) > 0 of true -> [{X}|Acc]; _ -> [] end.

wildcards(Depot,X,Pattern) ->
    mad_repl:wildcards([Depot++atom_to_list(X)++Pattern]).

atomlist(TARGETS) ->
    string:join(lists:map(fun(X) -> atom_to_list(X) end,TARGETS),",").

depot_release(Name) ->
    mad_resolve:main([]),
    TARGETS   = [beam,ling],
    HOSTS     = [mac,bsd,windows],
    Depot     = "/Users/5HT/depot/synrc/synrc.com/apps/",
    {ok,Apps} = file:consult(Depot++"index.txt"),
    Files     = lists:flatten([[
                    lists:foldl(fun(A,Acc) -> [{A}|Acc] end,
                        [], wildcards(Depot,X,lists:concat(["/ebin/**/*.{app,",atomlist(TARGETS),"}"]))),
                    lists:foldl(fun(B,Acc)->[contains(P,B,Acc)||P<-HOSTS] end,
                        [], wildcards(Depot,X,"/{bin,priv}/**/*")) ]
    || {_,[X],_} <- lists:flatten(Apps) ]),
    io:format("DEPOT Apps: ~p~n",[Files]),
    {ok,Name}.
