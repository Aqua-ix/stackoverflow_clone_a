# Server実習3日目

# 内容

* `Question` APIとして下記のAPIを実装する
  * `retrieveQuestionList API` (`GET  /v1/question`)
    * API自体はすでにあるが、request parameterとして`user_id`が指定された場合は、その指定された値をもつquestionのみを返すように拡張する。

* `Answer` APIとして下記のAPIを実装する
  * `retrieveAnswer API` (`GET  /v1/answer/{id}`)
    * API自体はすでにあるが、request parameterとして`user_id`または`question_id`が指定された場合は、その指定された値をもつanswerのみを返すように拡張する。

# これらのAPIが必要になる場面

* Questionの検索
  * 特定のuser_idをもつQuestionの検索
    * [マイページ](https://stackoverflow-clone.solomondev.access-company.com/#/user/5ae11b7c3800003800cee3af)で自分自身が過去行ったAnswerの一覧を表示するために必要
* Answerの検索
  * 特定のquestion_idをもつAnswerの検索
    * [この画面](https://stackoverflow-clone.solomondev.access-company.com/#/question/5cdcc2d8599107049a267c4b)のように、あるquestionに対する全ての回答を表示するために必要
  * 特定のuser_idをもつAnswerの検索
    * [マイページ](https://stackoverflow-clone.solomondev.access-company.com/#/user/5ae11b7c3800003800cee3af)で自分自身が過去行ったAnswerの一覧を表示するために必要

# 詳細

## 概要

今までは、[index関数](../web/controller/question.ex)では下記のように検索条件を何も指定しなかったため、全てのQuestion/Answerが取得されていた。(正確にはsort条件としてid順となる条件だけ指定している)
```
# 第一引数が検索条件
# 現在は %{sort: %{"_id" => 1}} という「ソート順が_id順である」という条件のみが指定されている。
RQ.retrieve_list(%{sort: %{"_id" => 1}}, StackoverflowCloneAA.Dodai.root_key())
```
本日の実装では、Question/Answerをdodaiから取得するときに「検索条件」を指定して検索することが必要になる。

## 実装の流れ

実装の流れは下記。
* userが指定した値をconnのquery parameterから取得する
  * 検索条件の`user_id`や`question_id`はuserが指定
* 上記を値をもとに検索条件(`StackoverflowCloneA.Repo.Question.retrieve_list/3`の第一引数)を指定する

## 検索条件の指定方法

* どういったdocumentを取得するかという「検索条件」は`StackoverflowCloneAA.Repo.Question.retrieve_list/3`の第一引数で指定できる
* `StackoverflowCloneAA.Repo.Question.retrieve_list`関数の定義は下記
  ```
  iex(1)> h StackoverflowCloneAA.Repo.Question.retrieve_list

                  def retrieve_list(list_action, key, opts \\ [])

    @spec retrieve_list(
            AntikytheraAcs.Dodai.Repo.Datastore.list_action_t(),
            String.t(),
            [AntikytheraAcs.Dodai.Repo.Datastore.option_t()] | Dodai.GroupId.t()
          ) :: Croma.Result.t([StackoverflowCloneA.Model.Question.t()])
  ```
* 第一引数の`AntikytheraAcs.Dodai.Repo.Datastore.list_action_t`は下記のように定義されている
  ```
  iex(1)> t AntikytheraAcs.Dodai.Repo.Datastore.list_action_t
  @type list_action_t() :: %{
          optional(:query) => nil | Dodai.Query.t(),
          optional(:sort) => nil | Dodai.Sort.t(),
          optional(:limit) => nil | pos_integer(),
          optional(:skip) => nil | non_neg_integer(),
          optional(:projection) => nil | Dodai.Projection.t()
        }
  ```
  * 詳しい定義は、`Dodai.Query.t`などをさらに調べることになるが、ここでは[このAPIのドキュメント](https://github.com/access-company/Dodai-doc/blob/master/datastore_api.md#retrieve-multiple-documents-in-one-single-request)に書かれているquery parameterを引数と指定することになる。
    * 検索に使う条件はqueryパラメータで指定できる。
  * iex consoleで下記のように実行してみましょう。(hogeの部分は好きな文字列に変える)
    ```
    # data.bodyが"hoge"のものを取得
    > StackoverflowCloneA.Repo.Question.retrieve_list(%{query: %{"data.body": "hoge"}}, StackoverflowCloneA.Dodai.root_key())
    # 全てではなく2documentだけ取得
    > StackoverflowCloneA.Repo.Question.retrieve_list(%{limit: 2}, StackoverflowCloneA.Dodai.root_key())
    ```
* この実習ではこのように指定された`user_id`や`question_id`をもとに適切にStackoverflowCloneA.Repo.Question.retrieve_listを使うことが肝となる。
  * answerのquestion_idとuser_idはともにオプショナルのパラメータである点に注意。
    * 両方とも指定されていない場合は全answerが取得できなければならない
    * 片方だけが指定されていることもある
    * 両方共指定された場合はAND条件にする
* [Book API](../../web/controller/book/index.ex)が参考になる。
