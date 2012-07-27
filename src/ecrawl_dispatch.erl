-module(ecrawl_dispatch).

-export([start_link/0, init/1, handle_info/2, handle_cast/2]).

-behaviour(gen_server).

-record(state, {list, nkids=0, starttime}).

start_link() ->
    gen_server:start_link({local, ecrawl_dispatch}, ?MODULE, [], []).

init(Args) ->
    {ok, #state{starttime=calendar:now_to_datetime(now())}, 0}.

handle_cast({get_next, From}, State = #state{list=[H|Rest]}) ->
    gen_server:cast(From, {reply, H}),
    {noreply, State#state{list=Rest}};
handle_cast({get_next, From}, State= #state{list=[], starttime=StartT}) ->
    gen_server:cast(From, done),
    T = calendar:now_to_datetime(now()),
    io:format("######################### TIMESTAMP ################ : ~p~n", [calendar:time_difference(T-StartT)]),
    {noreply, State#state{list=[]}};
handle_cast(dying, State = #state{nkids = NKids}) ->
    io:format("Term~p~n", [NKids]),
    {noreply, State#state{nkids=NKids+1}}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

handle_info(timeout, State) ->
    {ok, Data} = file:read_file('priv/top-1m.csv'),
    {noreply, State#state{list=re:split(Data, "\n")}}.

