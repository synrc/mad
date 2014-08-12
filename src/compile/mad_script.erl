-module(mad_script).
-compile(export_all).

script(ConfigFile, Conf, Name) ->
    File = ConfigFile ++ ".script",
    Filename = filename:basename(File),
    case file:script(File, [{'CONFIG', Conf}, {'SCRIPT', File}]) of
        {ok, {error,_}} -> Conf;
        {ok, Out} -> Out;
        {error, _} -> Conf
    end.
