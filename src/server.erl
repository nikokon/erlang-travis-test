-module(server).
-author("Tommy Mattsson").
-include("include/server.hrl").
-include("include/tcp_opts.hrl").
-export([start/0, server/0]).



start() ->
    register(server, spawn(server, server, [])),
    register(listener, spawn(listener, start, [])).
    
server() ->
    State = #server_state{},
    loop(State).
    
    



loop(State) ->
    receive
	{online, Name, Pid} ->
	    LocalPeers = State#server_state.local_peers,
	    NewLocalPeers = [{Name, Pid} | LocalPeers],
	    NewState = State#server_state{local_peers = NewLocalPeers},
	    io:format("Peer Online: ~s~n", [Name]),
	    loop(NewState);
	{msg, Msg, Name, Pid} ->
	    io:format("Local msg from ~s; ~s~n", [Name, Msg]),
	    Pid ! {msg_received, Msg},
	    loop(State);
	{tcp, Socket, "ONLINE::" ++ Name} ->
	    RemotePeers = State#server_state.remote_peers,
	    NewRemotePeers = [{Name, Socket} | RemotePeers],
	    NewState = State#server_state{remote_peers = NewRemotePeers},
	    io:format("Peer Online: ~s~n", [Name]),
	    loop(NewState);
	{tcp, Socket, Msg} ->
	    RemotePeers = State#server_state.remote_peers,
	    {Name, Socket} = lists:keyfind(Socket, 2, RemotePeers),
	    io:format("Remote msg from ~s; ~s~n", [Name, Msg]),
	    gen_tcp:send(Socket, "msg_received"++Msg),
	    loop(State)
    after 
	?TIMEOUT ->
	    io:format("Server: No messages received, timing out~n"),
	    loop(State)
    end.
	      
	    
	     
	    
