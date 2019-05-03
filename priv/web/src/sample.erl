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
init([])   -> kvs:join(), {ok, {{one_for_one, 5, 10}, [] }}.
port()     -> application:get_env(n2o,port,8001).
rebar3()   -> {ok,[{_,R,L}]}=file:consult(code:lib_dir(sample)++"/ebin/sample.app"),
              [ application:start(X) || X <- proplists:get_value(applications,L,[]) ],
              application:start(R).
