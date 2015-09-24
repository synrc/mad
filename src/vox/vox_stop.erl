-module(vox_stop).
-compile(export_all).

command(Args) -> vox:info("~p Args: ~p~n",[?MODULE,Args]), {ok,?MODULE}.

