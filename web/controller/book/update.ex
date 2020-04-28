use Croma

defmodule StackoverflowCloneA.Controller.Book.Update do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.Book
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.Error.{BadRequest, ResourceNotFound}
  alias StackoverflowCloneA.Controller.Book.Helper

  defmodule RequestBody do
    use Croma.Struct, fields: [
      title:  Croma.TypeGen.nilable(Book.Title),
      author: Croma.TypeGen.nilable(Book.Author),
    ]
  end

  defun update(%Conn{request: %Request{path_matches: %{id: id}, body: body}} = conn) :: Conn.t do
    case RequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequest.new())
      {:ok, validated} ->
        data = to_update_document(validated)
        res = RB.update(%{data: data}, id, StackoverflowCloneA.Dodai.root_key())
        case res do
          {:ok, book}                         -> Conn.json(conn, 200, Helper.to_response_body(book))
          {:error, %Dodai.ResourceNotFound{}} -> ErrorJson.json_by_error(conn, ResourceNotFound.new())
        end
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
