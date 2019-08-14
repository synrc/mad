-module(mad_groff).
-copyright('Taras Taraskin').
-include_lib("xmerl/include/xmerl.hrl").
-compile([export_all, nowarn_export_all]).

do(FileName) ->
  {#xmlElement{content=[#xmlElement{content=Head}, BodyTree | _]}, _} = xmerl_scan:file(FileName),
  FN = string:join(lists:reverse(tl(lists:reverse(string:tokens(FileName,".")))),"."),
  Title = filename:basename(FN),
  Groff = "groff/"++FN,
  filelib:ensure_dir(filename:dirname(Groff)++"/"),
  write2new(Groff, lists:reverse( show(BodyTree, false, false,
    [ [".TH ", Title, " 1 \"",Title,"\" \"Synrc Research Center\" \"", head(Head, ""), "\"", "\n",
       ".SH NAME", "\n", Title, "\n"] ]))), ok.

show(#xmlElement{name=section,content=C},false,_,RA) -> S = check(C, false), child(C,S,[also(S)|RA]);
show(#xmlElement{content=C},false,_,RA) -> child(C,false,RA);
show(#xmlElement{name=h3,content=C},{true,S2},_,RA) -> child(C,{true,S2},[".SH ","\n"|RA]);
show(#xmlElement{name=a,content=[#xmlText{value=V}|_]},{true, last},_,RA) ->
  [["\\fB\\fI", V,"(1)","\\fR\\&\\fR\\&",", "]|RA];
show(#xmlElement{name=a,content=[#xmlText{value=V}|CM]},S,false,RA) ->
  child(CM, S, [["\\fI",V,"\\fR\\& "]|RA]);
show(#xmlElement{name=a,content=[#xmlText{value=V}|CM]},S,true,RA) ->
  child(CM, S, [["\\fI",V,"\\fR\\&"]|RA]);
show(#xmlElement{name=code,content=[#xmlText{value=V} | CM]},{true,S2},_,RA) ->
  child(CM, {true, S2}, [[".nf","\n",ltrim(V),".fi","\n"]|RA]);
show(#xmlElement{name=p,content=C}, {true, S2}, _, RA) -> child(C,{true,S2}, ["\n",".LP"|RA]);
show(#xmlElement{name=figcaption,  content=_C}, _S, _, RA) -> RA;
show(#xmlElement{name=_, content=C}, S, _, RA) -> child(C,S,RA);
show(_,false,_,RA) -> RA;
show(_,{true,last},_,RA) -> RA;
show(#xmlText{value=V},_S,_,RA) ->
  G = (hd(V) == 10) andalso (mad_man:trim(tl(V)) == ""),
  if G -> RA; true ->  [ltrim(V) | RA] end;
show(_,_,_,RA) -> RA.

check([#xmlElement{name=h3,content=C}|_], false) -> check(C, {true, h3});
check([#xmlElement{name=p,content=C}|_], false) -> check(C, {true, p});
check([#xmlText{value=V}|MoreNodes], false) ->
  G = (hd(V) == 10) andalso (mad_man:trim(tl(V)) == ""),
  if G -> check(MoreNodes, false); true -> {true, other} end;
check([], {true, h3}) -> {true, other};
check([#xmlText{value=_V} | _], {true, h3}) -> {true, usual};
check([_|_], {true, h3}) -> {true, other};
check([#xmlText{value=_V} | MoreNodes], {true, p}) -> hasa(MoreNodes);
check(_, _) -> {true, other}.

hasa([#xmlElement{name=a}|_]) -> {true, last};
hasa([#xmlElement{name=b,content=[#xmlElement{name=a}|_]}|_]) -> {true, last};
hasa([#xmlElement{name=b,content=[#xmlText{value=_V}, #xmlElement{name=a}|_]}|_])->{true, last};
hasa(_) -> {true, other}.

child([], _, RA) -> RA;
child([Node | MoreNodes], S, RA) ->
  Next_Is_Point = pt(S, Node, MoreNodes),
  child(MoreNodes, S, show(Node, S, Next_Is_Point, RA)).

pt({true,last},_,_) -> false;
pt(_,_,[]) -> false;
pt(_,#xmlElement{name=a},[#xmlText{value=V}|_])->
  V2=mad_man:trim(V),if V2 =/= "",hd(V2)==46->true;true->false end;
pt(_,_,_) -> false.

also({true, last}) -> ["\n", ".SH ALSO", "\n"];
also(_) -> "".

ltrim(V) ->
  [ [ mad_man:trim(V2), "\n"]
   || V2 <- string:tokens(V, "\n"),
      mad_man:trim(V2) =/= ""].

head([], A) -> A;
head([#xmlElement{name=title, content=[#xmlText{value=V} | _]} | _], _) -> V;
head([_|T], A) -> head(T, A).

write2new(F, S) ->
  file:write_file(F ++ ".1",
  io_lib:fwrite("~s", [
  mad_man:trim(
  unicode:characters_to_binary(S,utf8))]), [append]).
