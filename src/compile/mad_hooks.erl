-module(mad_hooks).
-compile(export_all).

%% --- hooks -- %%
apply_hooks(Mode, Config, Cwd, Name) ->
    Hooks = mad_utils:get_value(Mode, Config, []),
    Default = filename:join(Cwd, "deps"),
    DepsDir = filename:join(Cwd, mad_utils:get_value(deps_dir, Config, [Default])), 
    DepPath = filename:join(DepsDir, Name),
    Env = [{"REBAR_DEPS_DIR",DepsDir}],   
    lists:foreach(fun apply_hook/1, [{Env, DepPath, H}||H<-Hooks]).

apply_hook({Env, DepPath, {Arch, Command, Hook}}) ->
    case is_arch(Arch) of
        true ->
            apply_hook({Env, DepPath, {Command, Hook}});
        false ->
            ok
    end;
apply_hook({Env, DepPath, {Command, Hook}}) ->
    {_,Status,X} = sh:run("/bin/sh", ["-c", Hook], binary, DepPath, Env),   
    case Status == 0 of
         true -> skip;
         false -> mad:info("Shell Error ~p: ~s~n\r",
                            [Command, binary_to_list(X)]), exit({error,X}) 
    end.

wordsize() ->
    try erlang:system_info({wordsize, external}) of
        Val ->
            integer_to_list(8 * Val)
    catch
        error:badarg ->
            integer_to_list(8 * erlang:system_info(wordsize))
    end.

is_arch(ArchRegex) ->
    case re:run(get_arch(), ArchRegex, [{capture, none}]) of
        match ->
            true;
        nomatch ->
            false
    end.

get_arch() ->
    Words = wordsize(),
    otp_release() ++ "-"
        ++ erlang:system_info(system_architecture) ++ "-" ++ Words.


otp_release() ->
    otp_release1(erlang:system_info(otp_release)).

%% If OTP <= R16, otp_release is already what we want.
otp_release1([$R,N|_]=Rel) when is_integer(N) ->
    Rel;
%% If OTP >= 17.x, erlang:system_info(otp_release) returns just the
%% major version number, we have to read the full version from
%% a file. See http://www.erlang.org/doc/system_principles/versions.html
%% Read vsn string from the 'OTP_VERSION' file and return as list without
%% the "\n".
otp_release1(Rel) ->
    File = filename:join([code:root_dir(), "releases", Rel, "OTP_VERSION"]),
    {ok, Vsn} = file:read_file(File),

    %% It's fine to rely on the binary module here because we can
    %% be sure that it's available when the otp_release string does
    %% not begin with $R.
    Size = byte_size(Vsn),
    %% The shortest vsn string consists of at least two digits
    %% followed by "\n". Therefore, it's safe to assume Size >= 3.
    case binary:part(Vsn, {Size, -3}) of
        <<"**\n">> ->
            %% The OTP documentation mentions that a system patched
            %% using the otp_patch_apply tool available to licensed
            %% customers will leave a '**' suffix in the version as a
            %% flag saying the system consists of application versions
            %% from multiple OTP versions. We ignore this flag and
            %% drop the suffix, given for all intents and purposes, we
            %% cannot obtain relevant information from it as far as
            %% tooling is concerned.
            binary:bin_to_list(Vsn, {0, Size - 3});
        _ ->
            binary:bin_to_list(Vsn, {0, Size - 1})
    end.