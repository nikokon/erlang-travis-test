-module(listener).
-author("Tommy Mattsson").
-include("include/tcp_opts.hrl").
-export([start/0]).

start() ->
    %%Create the listen socket
    case gen_tcp:listen(?LISTEN_PORT, ?TCP_OPTS) of
	{ok, ListenSocket} ->
	    loop(ListenSocket);
	{error, E} ->
	    io:format("Listener: Failed to create listening socket: ~p~n", [E])
    end,
    io:format("Listener: I'm exiting~n", []).

%%Accept connections loop
loop(ListenSocket) ->
    case gen_tcp:accept(ListenSocket) of
	{ok, Socket} ->
	    %% Send the Socket to router (keeps track of incoming connections)
	    server ! {accepted, Socket},

	    %% Assign router as the controlling process of Socket, this will
	    %% cause all traffic coming to Socket to go to the process router
	    gen_tcp:controlling_process(Socket, whereis(server));
	{error, E} ->
	    io:format("Listener: Error ~p Socket ~p~n", [E, ListenSocket])
    end,
    loop(ListenSocket).
