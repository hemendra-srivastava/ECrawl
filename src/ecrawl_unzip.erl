-module(ecrawl_unzip).

-export([unzip/0]).

unzip() ->
    Li = filelib:wildcard("priv/results/*"),
    F = fun(X) ->
		{ok, Bin} = file:read_file(X),
		["priv", "results", FName] = re:split(X, "/"),
		Data = erlang:binary_to_list(zlib:unzip(Bin)),
		file:write_file("priv/unzipped_data/"++FName++".html", Data)
	end,
    lists:foreach(F, Li).
		
