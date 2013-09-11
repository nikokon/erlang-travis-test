-module(client).
-author("Tommy Mattsson").
-include("include/client.hrl").
-include("include/tcp_opts.hrl").
-export([start/2, start_local/1, start_remote/1, send_local_msg/1, send_remote_msg/1]).

%%% Type :: remote | local
start(local, Name) ->
    register(local_client, spawn(client, start_local, [Name]));
start(remote, Name) ->
    register(remote_client, spawn(client, start_remote, [Name])).



start_local(Name) ->
    State = #state{name = Name},
    local_loop(State).

start_remote(Name) ->
    {ok, Socket} = gen_tcp:connect(?IP, ?LISTEN_PORT, ?TCP_OPTS),
    gen_tcp:send(Socket, "ONLINE::" ++ Name),    
    State = #state{name = Name, socket = Socket},
    remote_loop(State).

    
local_loop(State) ->
    io:format("Local Client: Enter Loop~n", []),
    receive
	{send_msg, Msg} ->
	    server ! {msg, Msg, State#state.name, self()},
	    io:format("Sent Msg :~n~s~n", [Msg]),
	    local_loop(State);
	{msg_received, Msg} ->
	    io:format("Msg sucessfully delivered:~n~s~n", [Msg]),
	    local_loop(State)
    end,
    io:format("Local Client: Exits~n", []).

remote_loop(#state{socket = Socket} = State) ->
    io:format("Remote Client: Enter Loop~n", []),
    receive
	{send_msg, Msg} ->
	    gen_tcp:send(Socket, Msg),
	    io:format("Sent Msg :~n~s~n", [Msg]),
	    remote_loop(State);
	{tcp, Socket, "Msg sucessfully delivered:"++Msg} ->
	    io:format("Msg sucessfully delivered:~n~s~n", [Msg]),
	    remote_loop(State)
    end,
    io:format("Remote Client: Exits~n", []).
	    

send_local_msg(Msg) ->
    local_client ! {send_msg, Msg}.

send_remote_msg(Msg) ->
    remote_client ! {send_msg, Msg}.


