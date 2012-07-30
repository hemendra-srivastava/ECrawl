-module(ecrawl_crawl_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok,{{one_for_one, 5, 10}, generate_childspec(30)}}.

generate_childspec(No) ->
    Li = lists:seq(1, No, 1),
    lists:map(
      fun(X) ->
	      {erlang:integer_to_list(X) ++ "crawler",
	       {ecrawl_crawl, start_link, []}, transient, 5000, worker, [ecrawl_crawl]}
      end,
      Li).
