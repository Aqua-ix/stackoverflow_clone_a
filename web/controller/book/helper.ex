use Croma

defmodule StackoverflowCloneA.Controller.Book.Helper do
  alias StackoverflowCloneA.Model.Book

  defun to_response_body(book :: v[Book.t]) :: map do
    StackoverflowCloneA.MapUtil.from_struct_recursively(book)
    |> Map.fetch!(:data)
    |> Map.put(:id, book._id)
  end
end
