-module(mad_hooks).
-copyright('Pavel Kozlovsky').
-export([run_hooks/2]).

-spec run_hooks(pre|post, atom()) -> any().
run_hooks(Type, Command) ->
    case mad_utils:configs() of
         {error,E} -> {error,E};
         {ok,{_Cwd, _ConfigFile, Config}} ->
             Dir = mad_utils:cwd(),
             run_hooks(Dir, Type, Command, Config) end.

run_hooks(Dir, pre, Command, Config) -> run_hooks(Dir, pre_hooks, Command, Config);
run_hooks(Dir, post, Command, Config) -> run_hooks(Dir, post_hooks, Command, Config);
run_hooks(Dir, Type, Command, Config) ->
    MaybeHooks = mad_utils:get_value(Type, Config, []),
    apply_hooks(Dir, Command, Config, MaybeHooks).

apply_hooks(_, _, _, []) -> done;
apply_hooks(Dir, Command, Config, Hooks) ->
    Env = create_env(Config),
    lists:foreach(fun({_, C, _} = Hook) when C =:= Command ->
        apply_hook(Dir, Env, Hook);
    ({C, _} = Hook) when C =:= Command ->
        apply_hook(Dir, Env, Hook);
    (_) ->
        continue
    end, Hooks).

apply_hook(Dir, Env, {Arch, Command, Hook}) ->
    case is_arch(Arch) of
        true ->
            apply_hook(Dir, Env, {Command, Hook});
        false ->
            ok
    end;
apply_hook(Dir, Env, {Command, Hook}) ->
    sh(Command, Hook, Dir, Env).

%% Can be expanded
create_env(_Config) -> [].

%% SOURCE:
%%  https://github.com/erlang/rebar3/blob/master/src/rebar_utils.erl
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

wordsize() ->
    try erlang:system_info({wordsize, external}) of
        Val ->
            integer_to_list(8 * Val)
    catch
        error:badarg ->
            integer_to_list(8 * erlang:system_info(wordsize))
    end.

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
    case file:read_file(File) of
        {error, _} ->
            Rel;
        {ok, Vsn} ->
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
            end
    end.
%% END of SOURCE

sh(Command, Hook, Dir, Env) ->
    Port = erlang:open_port({spawn, Hook},
        [
            stream,
            stderr_to_stdout,
            binary,
            exit_status,
            {cd, Dir},
            {env, Env}
        ]
    ),
    {done, Status, Out} = sh:sh_loop(Port, binary),
    case Status of
        0 ->
            mad:info("~s~n", [Out]);
        _ ->
            mad:info("Failed hook for ~p with ~s~n", [Command, Out]),
            exit({error, Out})
    end.