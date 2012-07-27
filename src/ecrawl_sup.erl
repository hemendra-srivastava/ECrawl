-module(ecrawl_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/3]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Url, Port, Nreq) ->
    supervisor:start_child(?MODULE, [Url, Port, Nreq]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, 
     { 
       {rest_for_one, 5, 10}, [
			      ?CHILD(ecrawl_dispatch, worker),
			      ?CHILD(ecrawl_crawl_sup, supervisor)
			     ]
     } 
    }.

