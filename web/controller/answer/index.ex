use Croma
defmodule StackoverflowCloneA.Controller.Answer.Index do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Controller.Answer.Helper
  alias StackoverflowCloneA.Repo.Answer, as: RA

  defun index(conn :: v[Conn.t]) :: Conn.t do
    query = %{sort: %{"_id" => 1}}
    {:ok, answers} = RA.retrieve_list(query, StackoverflowCloneA.Dodai.root_key())
    Conn.json(conn, 200, Enum.map(answers, &Helper.to_response_body/1))
  end
end