-module(helper).
-export([get_value/2]).

get_value(Key, Conf) ->
    case lists:keyfind(Key, 1, Conf) of
        {Key, Value} ->
            Value;
        _ ->
            undefined
    end.
