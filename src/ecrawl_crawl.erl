-module(ecrawl_crawl).

-behaviour(gen_server).

-export([start_link/0, init/1, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

init([]) ->  
    {ok, {}, 0}.

handle_cast({reply, Url}, State) ->
    process_data(re:split(Url, ",")),
    {noreply, State, 0};
handle_cast(done, State) ->
    io:format("Terminating~n", []),
    gen_server:cast(ecrawl_dispatch, dying),
    {stop, shutdown, State}.

handle_info(timeout, State) ->
    gen_server:cast(ecrawl_dispatch, {get_next, self()}),
    {noreply, State}.

process_data([Rank, Uri]) ->
    io:format("Received URL: ~p - ~p~n", [Rank, Uri]),
    Url = "http://www." ++ erlang:binary_to_list(Uri),
    case httpc:request(Url) of
	{ok, Response} ->
	    write_to_file(Rank, Response);
	_ ->
	    error
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

write_to_file(Rank, Data) ->
    [Html|Rest] = lists:reverse(erlang:tuple_to_list(Data)),
    case search_for(Html) of
	{ok, Str} ->
	    {ok, Fd} = file:open("priv/results/" ++ erlang:binary_to_list(Rank) ++ Str, write),
	    file:write(Fd, zlib:zip(Html)),
	    file:close(Fd);
	_ ->
	    error
    end.

search_for(Html) ->
    Search_List = ["munchkin", "trackalyze", "elqCfg", "elqImg"],
    Str = lists:foldl(
	    fun (X, Str) ->
		    case re:run(Html, X ++ ".js") of
			{match, _} ->
			    X;
			nomatch ->
			    Str;
			_ ->
			    Str
		    end
	    end,
	    "NF",
	    Search_List),
    {ok, Str}.
