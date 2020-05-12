defmodule StackoverflowCloneA.Controller.Answer.Show do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.Controller.Answer.Helper
  def show(%Conn{request: %Request{path_matches: %{id: id}}} = conn) do
    res = RA.retrieve(id, StackoverflowCloneA.Dodai.root_key())
    case res do
      {:ok, answer}  -> Conn.json(conn, 200, Helper.to_response_body(answer))
      # Questionの取得に失敗した場合は、エラーを返します。
      {:error, _}      -> ErrorJson.json_by_error(conn, StackoverflowCloneA.Error.ResourceNotFound.new())
    end
  end
end
