-module(sample).
-behaviour(supervisor).
-behaviour(application).
-compile(export_all).
main(A)    -> mad:main(A).
stop(_)    -> ok.
start()    -> start(normal,[]).
start(_,_) -> cowboy:start_tls(http,n2o_cowboy:env(?MODULE),
                 #{env=>#{dispatch=>n2o_cowboy2:points() }}),
              supervisor:start_link({local,sample},sample,[]).
init([])   -> kvs:join(), syn:init(), {ok, {{one_for_one, 5, 10}, [] }}.
