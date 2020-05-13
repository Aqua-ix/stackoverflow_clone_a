use Croma

defmodule StackoverflowCloneA.Controller.Question.Update do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.User
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Error.{BadRequest, ResourceNotFound, InvalidCredential}
  alias StackoverflowCloneA.Controller.Question.Helper

  plug StackoverflowCloneA.Plug.FetchMe, :fetch, []

  # パラメータvalidation用のmodule
  defmodule RequestBody do
    alias StackoverflowCloneA.Model.Question
    use Croma.Struct, fields: [
      title:              Croma.TypeGen.nilable(Question.Title),
      body:               Croma.TypeGen.nilable(Question.Body),
    ]
  end

  defun update(%Conn{request: %Request{path_matches: %{id: id}, body: body}, assigns: %{me: %User{_id: user_id}}} = conn) :: Conn.t do
    # 第二引数で指定したidのquestionを取得するための関数です。
    with_question(conn, id, fn question ->
      if question.data.user_id != user_id do
        ErrorJson.json_by_error(conn, InvalidCredential.new())
      else
        case RequestBody.new(body) do
          {:error, _}      ->
            ErrorJson.json_by_error(conn, BadRequest.new())
          {:ok, validated} ->
            data = to_update_document(validated)
            res = RQ.update(%{data: data}, id, StackoverflowCloneA.Dodai.root_key())
            case res do
              {:ok, question}                     -> Conn.json(conn, 200, Helper.to_response_body(question))
              {:error, %Dodai.ResourceNotFound{}} -> ErrorJson.json_by_error(conn, ResourceNotFound.new())
            end
        end
      end
    end)
  end

  defun with_question(conn :: v[Conn.t], id :: v[DodaiId.t], f :: ((map) -> Conn.t)) :: Conn.t do
    res = RQ.retrieve(id, StackoverflowCloneA.Dodai.root_key())
    case res do
      # Questionの取得に成功した場合は、第3引数で指定された関数を実行します。
      {:ok, question}  -> f.(question)
      # Questionの取得に失敗した場合は、エラーを返します。
      {:error, _}      -> ErrorJson.json_by_error(conn, StackoverflowCloneA.Error.ResourceNotFound.new())
    end
  end

  defunp to_update_document(body :: v[RequestBody.t]) :: map do
    data =
      Map.from_struct(body)
      |> Enum.reject(fn {_, value} -> is_nil(value) end)
      |> Enum.into(%{})
    %{"$set" => data}
  end

end
