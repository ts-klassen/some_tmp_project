-module(recomendar).

-export([
        main/1
    ]).

-define(NAMESPACE, <<"recomendar_v4">>).
-define(CATEGORY_LIST, [<<"development">>, <<"networking">>, <<"administration">>]).

main(_) ->
    IdList = id_list(),
    reset_recommendations(IdList),
    AllCategory = lists_map(fun(Id)->
        Evaluate = evaluate(IdList),
        add_recommendations_with_all_category(Id),
        Evaluate
    end, lists:sublist(100, IdList)),
    report(<<"all_category">>, AllCategory),
    reset_recommendations(IdList),
    CorrectCategory = lists_map(fun(Id)->
        Evaluate = evaluate(IdList),
        add_recommendations(Id),
        Evaluate
    end, lists:sublist(100, IdList)),
    report(<<"correct_category">>, CorrectCategory),
    {AllCategory, CorrectCategory}.

report(Dir, Data) ->
    DirPath = filename:join(code:priv_dir(recomendar), Dir),
    file:make_dir(DirPath),
    N = length(Data),
    lists:map(fun(Key)->
        Path = filename:join(DirPath, <<Key/binary, ".dat">>),
        TSV = iolist_to_binary(lists:map(fun(Elem)->
            {X, Y} = maps:get(Key, Elem),
            [klsn_binstr:from_any(N-X), <<"\t">>, klsn_binstr:from_any(Y), <<"\n">>]
        end, Data)),
        file:write_file(Path, TSV)
    end, ?CATEGORY_LIST).
    

add_recommendations(Id) ->
    CategoryList = maps:get(<<"category">>, embe:get(Id, embe:new(?NAMESPACE))),
    lists:map(fun(Category) ->
        Embe = embe:recommendation_key(Category, embe:new(?NAMESPACE)),
        embe:positive(Id, Embe)
    end, CategoryList).

add_recommendations_with_all_category(Id) ->
    lists:map(fun(Category) ->
        Embe = embe:recommendation_key(Category, embe:new(?NAMESPACE)),
        embe:positive(Id, Embe)
    end, ?CATEGORY_LIST).

reset_recommendations(IdList) ->
    lists:map(fun(Id) ->
        lists:map(fun(Category) ->
            Embe = embe:recommendation_key(Category, embe:new(?NAMESPACE)),
            embe:neutral(Id, Embe)
        end, ?CATEGORY_LIST)
    end, IdList).

evaluate(IdList) ->
    maps:from_list(lists:map(fun(Category)->
        {Category, evaluate(Category, IdList)}
    end, ?CATEGORY_LIST)).

evaluate(Category, IdList) ->
    N = length(IdList),
    Embe = embe:recommendation_key(Category, embe:new(?NAMESPACE)),
    Recommends = embe:recommendations(#{limit => 9999*N}, Embe),
    IsMemberList = lists:map(fun(#{<<"metadata">>:=#{<<"category">>:=Expected}})->
        lists:member(Category, Expected)
    end, Recommends),
    {length(Recommends), inversion_count(IsMemberList)}.

inversion_count(List) ->
    inversion_count(List, 0).

inversion_count([], Count) ->
    Count;
inversion_count([true|List], Count) ->
    inversion_count(List, Count);
inversion_count([false|List], Count0) ->
    Count = Count0 + length(lists:filter(fun(X) -> X end, List)),
    inversion_count(List, Count).

id_list() ->
    IdListPath = filename:join(code:priv_dir(recomendar), "id_list.json"),
    case file:read_file(IdListPath) of
        {ok, JSON} ->
            jsone:decode(JSON);
        _ ->
            insert_dataset()
    end.

insert_dataset() ->
    DatasetPath = filename:join(code:priv_dir(recomendar), "embeddings.json"),
    {ok, DatasetJSON} = file:read_file(DatasetPath),
    Dataset = jsone:decode(DatasetJSON),
    IdList = lists:map(fun(Elem)->
        insert_dataset(Elem)
    end, Dataset),
    IdListPath = filename:join(code:priv_dir(recomendar), "id_list.json"),
    file:write_file(IdListPath, jsone:encode(IdList)),
    IdList.

insert_dataset(#{<<"question">>:=Input, <<"category">>:=Category, <<"vector">>:=Vector}) ->
    Embe0 = embe:new(?NAMESPACE),
    Embe = Embe0#{ embeddings_function := fun(I) when I =:= Input -> Vector end },
    embe:add(#{input=>Input, category=>Category}, Embe).

lists_map(Fun, List) ->
    N = length(List),
    lists:map(fun({I, E}) ->
        io:format("~p/~p~n", [I, N]),
        Fun(E)
    end, lists:zip(lists:seq(1,N), List)).

