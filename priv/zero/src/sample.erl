-module(sample).
-compile(export_all).
-behaviour(application).
-behaviour(supervisor).
-export([start/2, stop/1, init/1]).

start(_, _) -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).
stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
