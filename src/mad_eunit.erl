-module(mad_eunit).
-compile(export_all).

bin(X) -> iolist_to_binary(lists:concat([X])).
main_test(_Params) ->
    case application:get_application() of
      {ok, App} -> try {ok,eunit:test([{application, App}])} catch _:Reason -> {error,bin(Reason)} end;
              _ -> try {ok,eunit:test()} catch _:Reason -> {error,bin(Reason)} end
    end.
