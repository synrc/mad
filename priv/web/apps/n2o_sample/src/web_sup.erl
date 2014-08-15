-module(web_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).
mime() -> [{mimetypes,cow_mimetypes,all}].
rules() -> cowboy_router:compile(
    [{'_', [
        {"/static/[...]", n2o_dynalo, {dir, "apps/n2o_sample/priv/static", mime()}},
        {"/n2o/[...]", n2o_dynalo, {dir, "deps/n2o/priv", mime()}},
        {"/rest/:resource", rest_cowboy, []},
        {"/rest/:resource/:id", rest_cowboy, []},
        {"/ws/[...]", bullet_handler, [{handler, n2o_bullet}]},
        {'_', n2o_cowboy, []}
    ]}]).

init([]) ->
    cowboy:start_http(http, 3, [{port, wf:config(n2o,port)}], [{env, [{dispatch, rules()}]}]),
    {ok, {{one_for_one, 5, 10}, []}}.
