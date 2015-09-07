-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").

peer()    -> wf:to_list(wf:peer(?REQ)).
message() -> wf:js_escape(wf:html_encode(wf:to_list(wf:q(message)))).
main()    -> #dtl{file="index",app=sample,bindings=[{body,body()}]}.
body()    -> [ #panel{id=history}, #textbox{id=message},
               #button{id=send,body="Chat",postback=chat,source=[message]} ].

event(init) -> wf:reg(room);
event(chat) -> wf:send(room,{client,{peer(),message()}});
event({client,{P,M}}) -> wf:insert_bottom(history,#panel{id=history,body=[P,": ",M,#br{}]});
event(Event) -> wf:info(?MODULE,"Unknown Event: ~p~n",[Event]).
