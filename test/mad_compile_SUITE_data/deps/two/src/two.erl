-module(two).

-export([ping/0]).
-export([test_inc_hrl/0]).
-export([test_src_hrl/0]).

ping() -> pong.

-include_lib("two_inc.hrl").
-include("two_src.hrl").
