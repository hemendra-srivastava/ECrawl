-module(ecrawl_dispatch).

-export([start_link/0, init/1, handle_info/2, handle_cast/2]).

-behaviour(gen_server).

-record(state, {list}).

start_link() ->
    gen_server:start_link({local, ecrawl_dispatch}, ?MODULE, [], []).

init(Args) ->
    {ok, #state{}, 0}.

handle_cast({get_next, From}, State = #state{list=[H|Rest]}) ->
    gen_server:cast(From, {reply, H}),
    {noreply, State#state{list=Rest}};
handle_cast({get_next, From}, State= #state{list=[]}) ->
    gen_server:cast(From, done),
    {noreply, State#state{list=[]}}.

handle_info(timeout, State) ->
    {ok, Data} = file:read_file('priv/top-1k.csv'),
    {noreply, State#state{list=re:split(Data, "\n")}}.

