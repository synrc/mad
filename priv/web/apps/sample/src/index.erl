-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

peer()    -> io_lib:format("~p",[wf:peer(?REQ)]).
message() -> wf:js_escape(wf:html_encode(wf:ql(message))).
main()    -> #dtl{file="index",app=n2o_sample,bindings=[{body,body()}]}.
body()    -> [ #panel{id=history}, #textbox{id=message},
               #button{id=send,body="Chat",postback=chat,source=[message]} ].

event(init) -> wf:reg(room);
event(chat) -> wf:send(room,{client,{peer(),message()}});
event({client,{Peer,Message}}) -> wf:insert_bottom(history,#panel{id=history,body=[Peer,": ",Message,#br{}]});
event(Event) -> wf:info(?MODULE,"Unknown Event: ~p~n",[Event]).
