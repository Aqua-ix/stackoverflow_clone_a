use Croma

defmodule StackoverflowCloneA.Controller.Book.Show do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.Error.ResourceNotFound
  alias StackoverflowCloneA.Controller.Book.Helper

  defun show(%Conn{request: %Request{path_matches: %{id: id}}} = conn) :: Conn.t do
    res = RB.retrieve(id, StackoverflowCloneA.Dodai.root_key())
    case res do
      {:ok, book}                         -> Conn.json(conn, 200, Helper.to_response_body(book))
      {:error, %Dodai.ResourceNotFound{}} -> ErrorJson.json_by_error(conn, ResourceNotFound.new())
    end
  end
end
