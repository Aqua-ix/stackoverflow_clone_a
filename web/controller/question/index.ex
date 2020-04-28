use Croma

defmodule StackoverflowCloneA.Controller.Question.Index do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Controller.Question.Helper
  alias StackoverflowCloneA.Repo.Question, as: RQ

  defun index(conn :: v[Conn.t]) :: Conn.t do
    query = %{sort: %{"_id" => 1}}
    {:ok, questions} = RQ.retrieve_list(query, StackoverflowCloneA.Dodai.root_key())
    Conn.json(conn, 200, Enum.map(questions, &Helper.to_response_body/1))
  end
end
