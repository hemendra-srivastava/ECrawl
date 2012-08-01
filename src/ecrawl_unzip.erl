-module(ecrawl_unzip).

-export([unzip/0]).

unzip() ->
    %% Li = filelib:wildcard("priv/results/1999*"),
    Li = create_list(),
    F = fun(X) ->
		{ok, Bin} = file:read_file(X),
		[<<"priv">>, <<"results">>, FName] = re:split(X, "/"),
		Data = erlang:binary_to_list(zlib:unzip(Bin)),
		file:write_file("priv/unzipped_data/"++erlang:binary_to_list(FName)++".html", Data)
	end,
    lists:foreach(F, Li).
		

create_list() ->
    lists:foldl(fun(X, Acc) -> filelib:wildcard("priv/results/"++erlang:integer_to_list(X)++"*"), [], lists:seq(2, 9, 1)).
