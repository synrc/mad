-module(mad_eunit).
-compile(export_all).

main_test(_Params) ->
    case application:get_application() of
      {ok, App} -> eunit:test([{application, App}]);
              _ -> eunit:test()
    end.