-module(web_app).
-behaviour(application).
-export([start/0, start/2, stop/1, main/1, log_modules/0]).

main(A) -> mad_repl:main(A,[]).
start() -> start(normal, []).
start(_StartType, _StartArgs) -> web_sup:start_link().
stop(_State) -> ok.

log_modules() -> [n2o_websocket,n2o_client,n2o_heart,n2o_nitrogen,bullet_handler].
