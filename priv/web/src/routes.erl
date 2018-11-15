-module(routes).
-include_lib("n2o/include/n2o.hrl").
-export([init/2, finish/2]).

finish(State, Ctx) -> {ok, State, Ctx}.
init(State, #cx{req=Req}=Cx) ->
    Path = case application:get_env(n2o,cowboy_spec,cow1) of
                cow1 -> n2o_cowboy:path(Req); % cowboy 1.0
                cow2 -> #{path:=P}=Req, P     % cowboy 2.5
           end,
    Fix  = route_prefix(Path),
    n2o:info(?MODULE,"Route: ~p~n",[{Fix,Path}]),
    {ok, State, Cx#cx{path=Path,module=Fix}}.

route_prefix(<<"/ws/",P/binary>>) -> route(P);
route_prefix(<<"/",P/binary>>) -> route(P);
route_prefix(P) -> route(P).

route(<<>>)              -> login;
route(<<"app/index",_/binary>>) -> index;
route(<<"app/login",_/binary>>) -> login;
route(_) -> login.
