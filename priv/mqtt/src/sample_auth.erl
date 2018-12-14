-module(sample_auth).
-include_lib("n2o/include/n2o.hrl").
-compile(export_all).

info({init, <<>>}, Req, State = #cx{session = Session}) ->
    {'Token', Token} = n2o_session:authenticate([], Session),
    #cx{params = _ClientId} = get(context),
    kvs:put({config, Token, State}),
    io:format("Token Saved: ~p~n",[Token]),
    n2o_nitro:info({init, Token}, Req, State);

% test protocol

info({load, <<>>}, Req, State = #cx{session = _Session}) ->
    #cx{params = ClientId} = get(context),
    M = "list of previous messages",
    n2o:send_reply(ClientId, 2, iolist_to_binary([<<"actions/1/index/">>,ClientId]), M),
    {reply, {binary, term_to_binary(<<>>)}, Req, State};

info({message, _Text} = M, Req, State = #cx{session = _Session}) ->
    #cx{params = ClientId} = get(context),
    n2o:send_reply(ClientId, 2, <<"room/global">>, M),
    {reply, {binary, term_to_binary(<<>>)}, Req, State};

info(Message,Req,State) -> {unknown,Message,Req,State}.
