-module(sample).
-behaviour(supervisor).
-behaviour(application).
-compile(export_all).
main(A)    -> mad:main(A).
stop(_)    -> ok.
start()    -> start(normal,[]).
start(_,_) -> case ver() of cow1 -> []; _ ->
                   cowboy:start_clear(http, [{port, port()}],
                      #{ env => #{dispatch => n2o_cowboy2:points()} })
              end, supervisor:start_link({local,sample},sample,[]).
init([])   -> kvs:join(), {ok, {{one_for_one, 5, 10}, ?MODULE:(ver())() }}.
ver()      -> application:get_env(n2o,cowboy_spec,cow2).
cow2()     -> [].
cow1()     -> [spec()].
port()     -> application:get_env(n2o,port,8001).
env()      -> [ { env, [ { dispatch, n2o_cowboy:points() } ] } ].
spec()     -> ranch:child_spec(http,100,ranch_tcp,[{port,port()}],cowboy_protocol,env()).
