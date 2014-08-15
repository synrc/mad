-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

peer()    -> io_lib:format("~p",[wf:peer(?REQ)]).
message() -> wf:js_escape(wf:html_encode(wf:q(message))).
main()    -> #dtl{file="index",app=n2o_sample,bindings=[{body,body()}]}.
body() ->
    {ok,Pid} = wf:comet(fun() -> chat_loop() end), 
    [ #panel{id=history}, #textbox{id=message},
      #button{id=send,body="Chat",postback={chat,Pid},source=[message]} ].

event(init) -> wf:reg(room);
event({chat,Pid}) -> Pid ! {peer(), message()};
event(Event) -> skip.

chat_loop() ->
    receive {Peer, Message} -> 
       wf:insert_bottom(history,#panel{id=history,body=[Peer,": ",Message,#br{}]}),
       wf:flush(room) end, chat_loop().
