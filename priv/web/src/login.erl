-module(login).
-compile(export_all).
-include_lib("kvs/include/feed.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").

main() -> [].
body() -> [].
event(init) ->
    nitro:update(loginButton,
      #button{id=loginButton,
              body="Login",postback=login,source=[user,pass]});
event(login) ->
    User = nitro:to_list(n2o:q(user)),
    Room = nitro:to_list(n2o:q(pass)),
    n2o:user(User),
    n2o:session(room,Room),
    n2o:info(?MODULE,"User: ~p",[User]),
    nitro:redirect("/app/index.htm?room="++Room),
    ok;
event(_) -> [].
