use Croma

defmodule StackoverflowCloneA.Comment do
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,1000}\z/u
  end
  use Croma.Struct, recursive_new?: true, fields: [
    id:         StackoverflowCloneA.DodaiId,
    body:       Body,
    user_id:    StackoverflowCloneA.DodaiId,
    created_at: Croma.String,
  ]
end

defmodule StackoverflowCloneA.CommentList do
  use Croma.SubtypeOfList, elem_module: StackoverflowCloneA.Comment
end
