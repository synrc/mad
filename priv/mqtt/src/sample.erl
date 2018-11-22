-module(sample).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/0, start/2, stop/1, main/1]).
-compile(export_all).

main(A)    -> mad:main(A).
init([])   -> {ok, {{one_for_one, 5, 10}, [spec()]}}.
start()    -> start(normal,[]).
start(_,_) -> emqttd_access_control:register_mod(auth, n2o_auth, [[]], 10),
              supervisor:start_link({local,sample},sample,[]).
stop(_)    -> ok.
spec()     ->
    Acceptors  = application:get_env(?MODULE, acceptors,   4),
    Clients    = application:get_env(?MODULE, max_clients, 512),
    Protocol   = application:get_env(?MODULE, protocol,    http),
    Port       = application:get_env(?MODULE, port,        8000),
    Options    = [{max_clients, Clients}, {acceptors, Acceptors}],
    Args       = [{mochiweb, handle, [docroot()]}],
    mochiweb:child_spec(Protocol, Port, Options, Args).

docroot() ->
    {file, Here} = code:is_loaded(?MODULE),
    Dir = filename:dirname(filename:dirname(Here)),
    Root = application:get_env(?MODULE, "statics_root", "priv/static"),
    filename:join([Dir, Root]).

rebar3()   -> mad_repl:application_config(mad_repl:load_sysconfig()),
              {ok,[{_,R,L}]}=file:consult(code:lib_dir(sample)++"/ebin/sample.app"),
              [ application:ensure_started(X) || X <- proplists:get_value(applications,L,[]) ],
              application:ensure_started(R).
