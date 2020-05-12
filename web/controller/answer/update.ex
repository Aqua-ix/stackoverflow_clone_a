use Croma
defmodule StackoverflowCloneA.Controller.Answer.Update do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.User
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.Error.{BadRequest, ResourceNotFound, InvalidCredential}
  alias StackoverflowCloneA.Controller.Answer.Helper

  plug StackoverflowCloneA.Plug.FetchMe, :fetch, []

  # パラメータvalidation用のmodule
  defmodule RequestBody do
    alias StackoverflowCloneA.Model.Answer
    use Croma.Struct, fields: [
      body:               Croma.TypeGen.nilable(Answer.Body),
    ]
  end

  defun update(%Conn{request: %Request{path_matches: %{id: id}, body: body}, assigns: %{me: %User{_id: user_id}}} = conn) :: Conn.t do
    # 第二引数で指定したidのanswerを取得するための関数です。
    with_answer(conn, id, fn answer ->
      # 更新対象のanswerのuser_idとログインユーザの_idが一致するか確認する
      if answer.data.user_id != user_id do
        ErrorJson.json_by_error(conn, InvalidCredential.new())
      else
        case RequestBody.new(body) do
          {:error, _}      ->
            ErrorJson.json_by_error(conn, BadRequest.new())
          {:ok, validated} ->
            data = to_update_document(validated)
            res = RA.update(%{data: data}, id, StackoverflowCloneA.Dodai.root_key())
            case res do
              {:ok, answer}                     -> Conn.json(conn, 200, Helper.to_response_body(answer))
              {:error, %Dodai.ResourceNotFound{}} -> ErrorJson.json_by_error(conn, ResourceNotFound.new())
            end
        end
      end
    end)
  end

  defun with_answer(conn :: v[Conn.t], id :: v[DodaiId.t], f :: ((map) -> Conn.t)) :: Conn.t do
    res = RA.retrieve(id, StackoverflowCloneA.Dodai.root_key())
    case res do
      # Answerの取得に成功した場合は、第3引数で指定された関数を実行します。
      {:ok, answer}  -> f.(answer)
      # Answerの取得に失敗した場合は、エラーを返します。
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
