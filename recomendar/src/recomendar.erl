-module(recomendar).

-export([
        main/1
    ]).

-define(NAMESPACE, <<"recomendar_v4">>).
-define(CATEGORY_LIST, [<<"development">>, <<"networking">>, <<"administration">>]).

main(_) ->
    IdList = id_list(),
    N = length(IdList),

    AllKey = embe_vector_db:uuid(),
    CorrectKey = embe_vector_db:uuid(),
    InitEvaluate = evaluate(IdList, 0, AllKey),

    {AllCategory, CorrectCategory} = lists:foldl(fun({I, Id}, {All0, Correct0}) ->
        add_recommendations(CorrectKey, Id),
        Correct = [evaluate(IdList, I, CorrectKey) | Correct0],
        add_recommendations_with_all_category(AllKey, Id),
        All = [evaluate(IdList, I, AllKey) | All0],
        io:format("~p/~p~n", [I, N]),
        case I rem 100 of
            0 ->
                io:format("start report~n"),
                report(<<"all_category">>, lists:reverse(All)),
                report(<<"correct_category">>, lists:reverse(Correct)),
                io:format("end report~n"),
                ok;
            _ ->
                ok
        end,
        {All, Correct}
    end, {[InitEvaluate], [InitEvaluate]}, lists:zip(lists:seq(1, N), IdList)),
    io:format("start final report~n"),
    report(<<"all_category">>, lists:reverse(AllCategory)),
    report(<<"correct_category">>, lists:reverse(CorrectCategory)),
    io:format("end final report~n"),
    {AllCategory, CorrectCategory}.

report(Dir, Data) ->
    DirPath = filename:join(code:priv_dir(recomendar), Dir),
    file:make_dir(DirPath),
    lists:map(fun(Key)->
        Path = filename:join(DirPath, <<Key/binary, ".dat">>),
        TSV = iolist_to_binary(lists:map(fun(Elem)->
            {X, Y} = maps:get(Key, Elem),
            [klsn_binstr:from_any(X), <<"\t">>, klsn_binstr:from_any(Y), <<"\n">>]
        end, Data)),
        file:write_file(Path, TSV)
    end, ?CATEGORY_LIST).
    

add_recommendations(Prefix, Id) ->
    CategoryList = maps:get(<<"category">>, embe:get(Id, embe:new(?NAMESPACE))),
    lists:map(fun(Category) ->
        Key = <<Prefix/binary, "_", Category/binary>>,
        Embe = embe:recommendation_key(Key, embe:new(?NAMESPACE)),
        embe:positive(Id, Embe)
    end, CategoryList).

add_recommendations_with_all_category(Prefix, Id) ->
    lists:map(fun(Category) ->
        Key = <<Prefix/binary, "_", Category/binary>>,
        Embe = embe:recommendation_key(Key, embe:new(?NAMESPACE)),
        embe:positive(Id, Embe)
    end, ?CATEGORY_LIST).

evaluate(IdList, I, Prefix) ->
    maps:from_list(lists:map(fun(Category)->
        {Category, evaluate(Category, IdList, I, Prefix)}
    end, ?CATEGORY_LIST)).

evaluate(Category, IdList, I, Prefix) ->
    N = length(IdList),
    Key = <<Prefix/binary, "_", Category/binary>>,
    Embe = embe:recommendation_key(Key, embe:new(?NAMESPACE)),
    Recommends = embe:recommendations(#{limit => 9999*N}, Embe),
    IsMemberList = lists:map(fun(#{<<"metadata">>:=#{<<"category">>:=Expected}})->
        lists:member(Category, Expected)
    end, Recommends),
    {I, inversion_count(IsMemberList)}.

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

