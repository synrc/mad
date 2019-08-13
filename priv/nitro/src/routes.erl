-module(routes).
-include_lib("n2o/include/n2o.hrl").
-export([init/2, finish/2]).

finish(State, Ctx) -> {ok, State, Ctx}.
init(State, #cx{req=Req}=Cx) ->
    #{path:=Path}=Req,
    {ok, State, Cx#cx{path=Path,module=route_prefix(Path)}}.

route_prefix(<<"/ws/",P/binary>>) -> route(P);
route_prefix(<<"/",P/binary>>) -> route(P);
route_prefix(P) -> route(P).

% Don't use fancy routers, be like poor man's pattern mach.

route(<<>>)              -> login;
route(<<"index",_/binary>>) -> index;   % github static
route(<<"login",_/binary>>) -> login;   % github static
route(<<"app/index",_/binary>>) -> index; % priv static
route(<<"app/login",_/binary>>) -> login; % priv static
route(_) -> login.
