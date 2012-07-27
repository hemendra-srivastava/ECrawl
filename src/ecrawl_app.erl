-module(ecrawl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    inets:start(),
    ecrawl_sup:start_link().

stop(_State) ->
    halt(0),
    ok.

