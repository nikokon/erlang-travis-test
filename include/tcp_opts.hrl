%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File:        tcp_opts.hrl
%%% Description: Include file for TCP options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Ip address of the server
-define(IP, {130,238,15,211}).

%% The port which our socket should listen to
-define(LISTEN_PORT, 35000).

%% TCP options for tcp socket.
%% What the options do:
%% 1. list atom specifies that we should receive data as lists of 
%%    bytes (ie strings) rather than binary objects
%% 2. {packet, 0}
%% 3. {keepalive, true}
%% 4. {active, true} all packets received go directly to the controlling process
%% 5. {reuseaddr, false}
-define(TCP_OPTS, [list
		   ,{packet, 0}
		   ,{keepalive, true}
		   ,{active, true}
		   %%, {reuseaddr, true} add this line later
		  ]).

-define(TIMEOUT, 60000).
