use Croma
defmodule StackoverflowCloneA.Controller.Question.Show do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Controller.Question.Helper
  def show(%Conn{request: %Request{path_matches: %{id: id}}} = conn) do
    res = RQ.retrieve(id, StackoverflowCloneA.Dodai.root_key())
    case res do
      {:ok, question}  -> Conn.json(conn, 200, Helper.to_response_body(question))
      {:error, _}      -> ErrorJson.json_by_error(conn, StackoverflowCloneA.Error.ResourceNotFound.new())
    end
  end
end



