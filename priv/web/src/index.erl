-module(index).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
body() -> [].
main() -> [].
event(init) ->
    Room = n2o:session(room),
    io:format("Room: ~p~n",[Room]),
    n2o:reg({topic,Room}),
    Sid = (get(context))#cx.session,
    n2o:reg(Sid),
    nitro:clear(history),
    nitro:update(logout, #button{id=logout, body="Logout " ++ n2o:user(), postback=logout}),
    nitro:update(heading, #h2{id=heading, body=Room}),
    nitro:update(upload, #upload{}),
    nitro:update(send, #button{id=send, body= <<"Chat">>, postback=chat, source=[message] }),
    [ event({client,{E#entry.from,E#entry.media}})
      || E <- lists:reverse(kvs:entries(kvs:get(feed,{room,Room}),entry,10)) ];
event(logout) ->
    n2o:user([]),
    nitro:redirect("/app/login.htm");
event(chat) ->
    User    = n2o:user(),
    Room    = n2o:session(room),
    Message = nitro:q(message),
    n2o:info(?MODULE,"Chat pressed: ~p~n",[{Room,Message,User}]),
    kvs:add(#entry{id=kvs:next_id("entry",1),from=n2o:user(),
                   feed_id={room,Room},media=Message}),
    n2o:send({topic,Room},#client{data={User,Message}});
event(#client{data={User,Message}}) ->
    HTML = nitro:to_list(Message),
    nitro:wire(#jq{target=message,method=[focus,select]}),
    DTL = #dtl{file="message",app=sample,bindings=[{user,User},{color,"gray"},{message,HTML}]},
    nitro:insert_top(history, nitro:jse(nitro:render(DTL)));
event(#ftp{sid=Sid,filename=Filename,status={event,stop}}=Data) ->
    Name = hd(lists:reverse(string:tokens(nitro:to_list(Filename),"/"))),
    erlang:put(message,nitro:render(#link{href=iolist_to_binary(["/app/",Sid,"/",nitro_conv:url_encode(Name)]),body=Name})),
    n2o:info(?MODULE,"FTP Delivered ~p~n",[Data]),
    event(chat);
event(Event) ->
    n2o:info(?MODULE,"Event: ~p", [Event]),
    ok.
