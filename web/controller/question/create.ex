use Croma

defmodule StackoverflowCloneA.Controller.Question.Create do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Controller.Question.Helper
  alias StackoverflowCloneA.Model.{User, Question}
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Error.BadRequest
  alias StackoverflowCloneA.Model.Question

  plug StackoverflowCloneA.Plug.FetchMe, :fetch, []

  defmodule RequestBody do
    use Croma.Struct, recursive_new?: true, fields: [
      title: Question.Title, 
      body:  Question.Body,
      tags:  Question.TagList,
    ]
  end

  defun create(%Conn{assigns: %{me: %User{_id: user_id}}} = conn :: v[Conn.t]) :: Conn.t do
    # RequestBody.new(body)がbodyが上で定義したRequestBodyの型をみたいしているかをチェック
    body = conn.request.body
    IO.inspect(body)
    case RequestBody.new(body) do
      # body値がRequestBodyの条件を満たしていない場合
      {:error, _}      ->
        # 下記の関数でエラーレスポンスを返す。
        # ErrorJson.json_by_error関数は第二引数で指定したエラーを返す
        ErrorJson.json_by_error(conn, BadRequest.new())

      # body値がRequestBodyの条件を満たしている場合
      {:ok, validated} ->
        data = %{
          "comments"          => [],
          "like_voter_ids"    => [],
          "dislike_voter_ids" => [],
          "title"             => validated.title,
          "body"              => validated.body,
          "user_id"           => user_id,
          "tags"              => validated.tags
        } |> Question.Data.new!()

        # 指定したdataでinsert関数を実行      
        {:ok, question} = RQ.insert(%{data: data}, StackoverflowCloneA.Dodai.root_key())
        # to_response_bodyはquestionをgearが返すレスポンスに変換する関数です。
        Conn.json(conn, 200, Helper.to_response_body(question))
    end
  end
end
