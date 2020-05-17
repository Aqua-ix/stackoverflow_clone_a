use Croma

defmodule StackoverflowCloneA.Model.Answer do
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,3000}\z/u
  end
  defmodule Comment do
    use Croma.Struct, recursive_new?: true, fields: [
      id: StackoverflowCloneA.DodaiId,
      body: Body,
      user_id: StackoverflowCloneA.DodaiId,
      created_at: Croma.String,
    ]
  end
  defmodule CommentList do
    use Croma.SubtypeOfList, elem_module: Comment
  end
  defmodule StackoverflowCloneA.DodaiId do
    # See [RFC3986](https://tools.ietf.org/html/rfc3986#section-2.3) for the specifications of URL-safe characters
    @url_safe_chars "0-9A-Za-z\-._~"
    use Croma.SubtypeOfString, pattern: ~r"\A[#{@url_safe_chars}]+\Z"
  end
  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    body:              Body,
    user_id:           StackoverflowCloneA.DodaiId,
    question_id:       StackoverflowCloneA.DodaiId,
    comments:          CommentList,
  ]
end
