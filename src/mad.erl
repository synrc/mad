-module(mad).
-copyright('Sina Samavati').
-export([main/1,'get-deps'/3,compile/3,'compile-app'/3,'compile-deps'/3]).

main([]) -> help();
main(Args) ->

    {Opts, Params} = case getopt:parse(option_spec_list(), Args) of
                         {ok, {Opts1, Params1}} ->
                             {Opts1, [list_to_atom(E) || E <- Params1]};
                         {error, {Reason, Data}} ->
                             help(Reason, Data)
                     end,
    maybe_invalid(Params),
    maybe_help(Opts, Params),

    Cwd = mad_utils:cwd(),
    ConfigFile = get_value(config_file, Opts, "rebar.config"),
    ConfigFileAbs = filename:join(Cwd, ConfigFile),
    Conf = mad_utils:consult(ConfigFileAbs),
    Conf1 = mad_utils:script(ConfigFileAbs, Conf),

    %% rebar should create deps dir in deps_dir only, this is not a list
    DepsDir = filename:join([mad_utils:get_value(deps_dir, Conf1, ["deps"]),"*","ebin"]),
    Paths = ["ebin"|filelib:wildcard(DepsDir)],
    code:add_paths(Paths),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(Cwd, Conf),
    code:add_paths(LibDirs),

    Fun = fun(F) -> ?MODULE:F(Cwd, ConfigFile, Conf1) end,
    lists:foreach(Fun, Params).

%% fetch dependencies
'get-deps'(Cwd, ConfigFile, Conf) ->
    case get_value(deps, Conf, []) of
        [] -> ok;
        Deps ->
            Cache = mad_utils:get_value(deps_dir, Conf, deps_fetch),
            case Cache of
                deps_fetch -> skip;
                Dir -> file:make_dir(Dir) end,
            FetchDir = mad_utils:get_value(deps_dir, Conf, ["deps"]),
            file:make_dir(FetchDir),
            mad_deps:fetch(Cwd, Conf, ConfigFile, Deps)
    end.

%% compile dependencies and the app
compile(Cwd, ConfigFile, Conf) ->
    %% compile dependencies
    'compile-deps'(Cwd, ConfigFile, Conf),

    %% compile the app
    'compile-app'(Cwd, ConfigFile, Conf).

%% compile a project according to the conventions
'compile-app'(Cwd, ConfigFile, Conf) ->
    %% check sub_dirs if they have something to be compiled
    Dirs = mad_utils:sub_dirs(Cwd, ConfigFile, Conf),
    mad_compile:foreach(fun mad_compile:app/3, Dirs, Conf, ConfigFile).

'compile-deps'(Cwd, ConfigFile, Conf) ->
    mad_compile:deps(Cwd, Conf, ConfigFile, get_value(deps, Conf, [])).

get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default end.

option_spec_list() ->
    [
     {help, $h, "help", undefined, "Displays this message"},
     {config_file, $C, "config", {string, "rebar.config"}, "Rebar config file to use"}
    ].

maybe_help(Opts, Params) ->
    Fun = fun(L) ->
                  case lists:member(help, L) of
                      true ->
                          help();
                      false ->
                          ok
                  end
          end,
    Fun(Opts),
    Fun(Params).

maybe_invalid(Params) ->
    lists:foreach(fun(E) ->
                          case erlang:function_exported(?MODULE, E, 3) of
                              true -> ok;
                              false -> help("invalid_parameter", E)
                          end
                  end, Params).

help("invalid_parameter", Data) ->
    help(io_lib:format("invalid_parameter \"~s\"", [Data]));
help(Reason, Data) ->
    help(io_lib:format("~s ~p", [Reason, Data])).

help(Msg) ->
    io:format("Error: ~s~n~n", [Msg]),
    help().

help() ->
    io:format("Erlang dependency manager~n"),
    Params = [
              {"", ""},
              {"get-deps", "Fetches dependencies"},
              {"compile-deps", "Compiles dependencies"},
              {"compile-app", "Compiles application"},
              {"compile", "Compiles dependencies and application"}
             ],
    getopt:usage(option_spec_list(), escript:script_name(), "", Params),
    halt().
