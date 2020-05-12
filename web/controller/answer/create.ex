use Croma

defmodule StackoverflowCloneA.Controller.Answer.Create do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Controller.Answer.Helper
  alias StackoverflowCloneA.Model.{User, Answer}
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Error.{ResourceNotFound, BadRequest}
  alias StackoverflowCloneA.Model.Answer

  plug StackoverflowCloneA.Plug.FetchMe, :fetch, []

  defmodule RequestBody do
    use Croma.Struct, recursive_new?: true, fields: [
      body: Answer.Body, 
      question_id: Answer.StackoverflowCloneA.DodaiId
    ]
  end

  defun create(%Conn{assigns: %{me: %User{_id: user_id}}} = conn :: v[Conn.t]) :: Conn.t do
    # RequestBody.new(body)がbodyが上で定義したRequestBodyの型をみたいしているかをチェック
    body = conn.request.body
    key = StackoverflowCloneA.Dodai.root_key()
    case RequestBody.new(body) do
      # body値がRequestBodyの条件を満たしていない場合
      {:error, _}      ->
        # 下記の関数でエラーレスポンスを返す。
        # ErrorJson.json_by_error関数は第二引数で指定したエラーを返す
        ErrorJson.json_by_error(conn, BadRequest.new())

      # body値がRequestBodyの条件を満たしている場合
      {:ok, validated} ->
        case with_question(validated.question_id, key) do
          {:error, ResourceNotFound} ->
            ErrorJson.json_by_error(conn, ResourceNotFound.new())
          {:ok, _} -> 
            data = %{
              "comments"        => [],
              "user_id"         => user_id,
              "body"            => validated.body,
              "question_id"     => validated.question_id
            } |> Answer.Data.new!()

            # 指定したdataでinsert関数を実行      
            {:ok, answer} = RA.insert(%{data: data}, key)
            # to_response_bodyはquestionをgearが返すレスポンスに変換する関数です。
            Conn.json(conn, 200, Helper.to_response_body(answer))
        end
    end
  end

  def with_question(id, key) do
    case RQ.retrieve(id, key) do
        {:ok, question} -> {:ok, question}
        {:error, _} -> {:error, ResourceNotFound}
    end
  end
end
