-module(mad_groff).
-copyright('Taras Taraskin').
-include_lib("xmerl/include/xmerl.hrl").
-compile([export_all, nowarn_export_all]).

do(FileName) ->
  {#xmlElement{content=[_, #xmlElement{content=Head}, _, BodyTree | _]}, _} = xmerl_scan:file(FileName),
  FN = string:join(lists:reverse(tl(lists:reverse(string:tokens(FileName,".")))),"."),
  Title = filename:basename(FN),
  Groff = "groff/"++FN,
  filelib:ensure_dir(filename:dirname(Groff)++"/"),
  write2new(Groff, lists:reverse( show(BodyTree, false,
    [ [".TH ", Title, " 1 \"",Title,"\" \"Synrc Research Center\" \"", head(Head, ""), "\"", "\n",
       ".SH NAME", "\n", Title] ]))), ok.

show(#xmlElement{name=section,content=C},false,RA) -> S = check(C, false), child(C,S,[also(S)|RA]);
show(#xmlElement{content=C},false,RA) -> child(C,false,RA);
show(#xmlElement{name=h3,content=C},{true,S2},RA) -> child(C,{true,S2},[["\n",".SH "]|RA]);
show(#xmlElement{name=a,content=[#xmlText{value=V}|_]},{true, last},RA) ->
  [["\\fB\\fI",V,"(1)","\\fR\\&\\fR\\&",", "]|RA];
show(#xmlElement{name=a,content=[#xmlText{value=V}|CM]},S,RA) ->
  child(CM, S, [["\\fI",V,"\\fR\\&"]|RA]);
show(#xmlElement{name=b,content=[#xmlText{value=V}|CM]},S,RA) when S =/= {true, last} ->
  child(CM, S, [["\\fB",V,"\\fR\\&"]|RA]);
show(#xmlElement{name=code,content=[#xmlText{value=V} | CM]},{true,S2},RA) ->
  child(CM, {true, S2}, [["\n",".nf","\n",V, "\n",".fi","\n"]|RA]);
show(#xmlElement{name=p,content=C}, {true, S2}, RA) -> child(C,{true,S2}, [["\n",".LP","\n"]|RA]);
show(#xmlElement{name=figcaption,  content=_C}, _S, RA) -> RA;
show(#xmlElement{name=_, content=C}, S, RA) -> child(C,S,RA);
show(_,false,RA) -> RA;
show(_,{true,last},RA) -> RA;
show(#xmlText{value=V},_S,RA) ->
  G = mad_man:trim2(V) == "",
  if G -> RA; true -> V2 = ltrim(V), [mad_man:sp( unicode:characters_to_list(V2,utf8)) | RA] end;
show(_,_,RA) -> RA.

check([#xmlElement{name=h3,content=C}|_], false) -> check(C, {true, h3});
check([#xmlElement{name=p,content=C}|_], false) -> check(C, {true, p});
check([#xmlText{value=V}|MoreNodes], false) ->
  G = mad_man:trim2(V) == "",
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
child([Node | MoreNodes], S, RA) -> child(MoreNodes, S, show(Node, S, RA)).

also({true, last}) -> ["\n", ".SH ALSO"];
also(_) -> "".

ltrim(V) ->
  S = string:tokens(V, "\n"),
  if length(S) == 1 -> mad_man:trim2(hd(S)); true -> 
  [ [mad_man:trim(V2), " "] || V2 <- string:tokens(V, "\n"), mad_man:trim2(V2) =/= ""] end.

head([], A) -> A;
head([#xmlElement{name=title, content=[#xmlText{value=V} | _]} | _], _) -> V;
head([_|T], A) -> head(T, A).

write2new(F, S) ->
  S2 = unicode:characters_to_binary(S,utf8),
  file:write_file(F ++ ".1", io_lib:fwrite("~s", [ binary:part(S2, 0, size(S2) - 2) ]), [append]).

