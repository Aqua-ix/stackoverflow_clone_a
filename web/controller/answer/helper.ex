use Croma

defmodule StackoverflowCloneA.Controller.Answer.Helper do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.Answer

  defun to_response_body(answer :: v[Answer.t]) :: map do
    StackoverflowCloneA.MapUtil.from_struct_recursively(answer.data)
    |> Map.merge(%{"id" => answer._id, "created_at" => StackoverflowCloneA.TimeUtil.to_iso_timestamp_sec(answer.created_at)})
  end
end
