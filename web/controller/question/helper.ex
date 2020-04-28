use Croma

defmodule StackoverflowCloneA.Controller.Question.Helper do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.Question

  defun to_response_body(question :: v[Question.t]) :: map do
    StackoverflowCloneA.MapUtil.from_struct_recursively(question.data)
    |> Map.merge(%{"id" => question._id, "created_at" => StackoverflowCloneA.TimeUtil.to_iso_timestamp_sec(question.created_at)})
  end
end
