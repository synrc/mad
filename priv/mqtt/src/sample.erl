-module(sample).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/0, start/2, stop/1, main/1]).
-compile(export_all).

main(A)    -> mad:main(A).
init([])   -> {ok, {{one_for_one, 5, 10}, [spec()]}}.
start()    -> start(normal,[]).
start(_,_) -> emqttd_access_control:register_mod(auth, n2o_auth, [[]], 9998),
              supervisor:start_link({local,sample},sample,[]).
stop(_)    -> ok.
spec()     ->
    Acceptors  = application:get_env(sample, acceptors,   4),
    Clients    = application:get_env(sample, max_clients, 512),
    Protocol   = application:get_env(sample, protocol,    http),
    Port       = application:get_env(sample, port,        8000),
    Options    = [{max_clients, Clients}, {acceptors, Acceptors}],
    Args       = [{mochiweb, handle, [docroot()]}],
    mochiweb:child_spec(Protocol, Port, Options, Args).

docroot() ->
    {file, Here} = code:is_loaded(sample),
    Dir = filename:dirname(filename:dirname(Here)),
    Root = application:get_env(sample, "statics_root", "priv/www"),
    filename:join([Dir, Root]).
