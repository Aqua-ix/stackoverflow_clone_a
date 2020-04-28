use Croma

defmodule StackoverflowCloneA.Controller.Book.Create do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.Book
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.Error.BadRequest
  alias StackoverflowCloneA.Controller.Book.Helper

  defmodule RequestBody do
    use Croma.Struct, fields: [
      title:  Book.Title,
      author: Book.Author,
    ]
  end

  defun create(%Conn{request: %Request{body: body}} = conn) :: Conn.t do
    case RequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequest.new())
      {:ok, validated} ->
        data = to_book_data(validated)
        {:ok, book} = RB.insert(%{data: data}, StackoverflowCloneA.Dodai.root_key())
        Conn.json(conn, 201, Helper.to_response_body(book))
    end
  end

  defunp to_book_data(body :: v[RequestBody.t]) :: Book.Data.t do
    Map.from_struct(body) |> Book.Data.new!()
  end
end
