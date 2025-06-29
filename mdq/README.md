# Multi-Department Question (MDQ) Embeddings Dataset

This repository contains a synthetic **question-only** embeddings corpus (no answers).

```
embeddings.json
```

Size: ≈ 1.2 GB Records: 14 541 ( `jq length embeddings.json` ) Vector dimension: 3 072 (OpenAI *text-embedding-3-large*)

---

## 1 Why this dataset?

Support desks often need to **route a user’s question to the correct department**—development, networking, or administration—*before* an agent even reads it.  With a labelled, vectorised corpus you can:

* Build semantic-search–powered triaging tools.
* Benchmark embedding models on multi-label classification.
* Prototype retrieval-augmented chat-bots.

## 2 Schema

Each JSON element has three keys:

| key        | type                    | description                                                                |
|------------|-------------------------|----------------------------------------------------------------------------|
| `question` | string (UTF-8)          | End-user question in plain English.                                        |
| `category` | array of enum strings   | One or more of `development`, `networking`, `administration`.              |
| `vector`   | array<float, 3 072>     | OpenAI *text-embedding-3-large* representation of the question.            |



## 3 Quick look with `jq`

```bash
# First two records
jq '.[0,1]' embeddings.json | less -R

# Same, but keep only the first five numbers of the vector
jq '.[0] | {question, category, vector: (.vector[0:5])}' embeddings.json
```

Example output (truncated):

```json
{
  "question": "How do I integrate our CRM system with your email API using OAuth2?",
  "category": ["development"],
  "vector": [-0.014554084, -0.027057962, -0.022015883, 0.0062519386, -0.003879897]
}
```

## 4 Loading the data in Python

```python
import json, numpy as np, pandas as pd

with open('embeddings.json', 'r') as f:
    data = json.load(f)

df = pd.json_normalize(data)          # question / category / vector
X  = np.vstack(df['vector'])          # shape = (n_samples, 3072)

print(df[['question', 'category']].head())
print(X.shape)
```

## 5 Disclaimers & trademarks

This dataset is entirely synthetic—every question was produced by a language model and does not contain personal data.

OpenAI®, GPT®, and related marks are trademarks of OpenAI LLC.

## 6 How the dataset was generated  *(for the curious)*

Everything is created programmatically—nothing is hand-labelled.

1. **Prompting** – `mdq.erl` (included below) defines a system prompt that asks GPT-4-o-mini to generate user questions for an e-mail marketing SaaS, each labelled with the relevant departments.
2. **Sampling** – Repeated calls to `chat_gpte:ask_n/3` (from the open-source [gpte](https://github.com/ts-klassen/gpte) library) collected 14 541 unique questions.
3. **Vectorisation** – Each question was embedded using OpenAI’s *text-embedding-3-large* (3 072-dimensional).
4. **Serialisation** – The resulting list was written to `embeddings.json`.

To reproduce you need Erlang, `rebar3`, and a valid `OPENAI_API_KEY`:

```bash
rebar3 shell <<'EOS'
mdq:main("embeddings.json").
halt().
EOS
```

## Appendix – `mdq.erl` (generation code)

```
-module(mdq).

-export([
        main/1
    ]).

-export_type([
        question_map/0
    ]).

-define(MODEL, <<"text-embedding-3-large">>).

-type question_map() :: #{
        questions := [#{
            question := unicode:unicode_binary(),
            category := [ development | networking | administration ]
        }]
    }.

prompt() -> <<"Generate a variety of user questions about a software product that focuses on email marketing for businesses. The product is used by companies to send bulk emails to their customers. 

Please include questions that fall into the following categories:
1) Development-related technical questions about features, bugs, or coding-related issues.
2) Networking or infrastructure-related questions about connectivity, server issues, or performance.
3) Management or administrative questions about permissions, policies, or user access.

Additionally, include a few mixed or ambiguous questions where it's not immediately clear which department should handle them. 

Note there are no enum called \"mixed\". If it's a mix of development and networking, the \"category\" should be [\"development\",\"networking\"].
NEVER USE `mixed` IN YOUR RESULT! THIS WILL CRASH THE PARSER!!

The company has three departments:

1. Development: 
   The Development team focuses on the technical aspects of the software. They handle everything related to coding, API integrations, software bugs, and implementing new features. If there’s a coding issue or a new feature that needs development, this team handles it. They also work on integration with external services via APIs.

2. Networking:
   The Networking team is responsible for the infrastructure and connectivity of the product. They handle issues related to servers, proxies, email delivery performance, and general network connectivity. When something is blocked by a proxy or there's a performance bottleneck, this team takes care of it.

3. Administration:
   The Administration team handles user access, permissions, and policies within the product. They take care of managing user roles, administrative tasks, and defining access levels for different users. If a user has permission issues or needs a policy update, this team is responsible.

Questions can fall into one or more of these categories. For example, a coding issue might be purely Development, while a connectivity issue may be Networking. Sometimes, questions overlap—for instance, an API permission issue could be both Development and Administration.

Please generate questions that respect these definitions and categorize them accordingly. Do not use a “mixed” category; instead, list multiple categories if the question spans more than one area.

">>.

main(FilePath) ->
    Chat0 = chat_gpte:model('o4-mini', chat_gpte:new()),
    Chat10 = chat_gpte:schema(gpte_schema:schema({mdq, question_map, 0}), Chat0),
    Res = lists:map(fun(N)->
        io:format("~p ", [N]),
        element(1, lists:unzip(chat_gpte:ask_n(prompt(), 8, Chat10)))
    end, lists:seq(1,100)),
    List = lists:flatten(lists:map(fun(Elem)->
        maps:get(questions, gpte_schema:schema({mdq, question_map, 0}, Elem))
    end, lists:flatten(Res))),
    Embeddings = lists:filtermap(fun(Elem=#{question:=Input})->
        try gpte_embeddings:simple(Input, ?MODEL) of
            Vector ->
                {true, Elem#{vector => Vector}}
        catch
            error:prompt_potentially_harmful ->
                false
        end
    end, List),
    file:write_file(FilePath, jsone:encode(Embeddings)).

```

