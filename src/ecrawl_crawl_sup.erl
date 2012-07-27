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
    {ok, 
     { 
       {rest_for_one, 5, 10}, [
			       {ecrawl_crawl1, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl2, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl3, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl4, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl5, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl6, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl7, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl8, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl9, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl10, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl11, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl12, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl13, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl14, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl15, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]},
			       {ecrawl_crawl16, {ecrawl_crawl, start_link, []}, permanent, 5000, worker, [ecrawl_crawl]}
			     ]
     } 
    }.

