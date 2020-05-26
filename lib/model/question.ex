use Croma
defmodule StackoverflowCloneA.Model.Question do
  defmodule Title do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,100}\z/u
  end
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,3000}\z/u
  end
  defmodule VoterIdList do
    use Croma.SubtypeOfList, elem_module: StackoverflowCloneA.DodaiId
  end
  defmodule CommentBody do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,1000}\z/u
  end
  defmodule Comment do
    use Croma.Struct, recursive_new?: true, fields: [
      id: Croma.String,
      body: CommentBody,
      user_id: StackoverflowCloneA.DodaiId,
      created_at: Croma.String,
    ]
  end
  defmodule CommentList do
    use Croma.SubtypeOfList, elem_module: Comment
  end
  defmodule Tag do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,10}\z/u
  end
  defmodule TagList do
    use Croma.SubtypeOfList, elem_module: Tag
  end
  defmodule StackoverflowCloneA.DodaiId do
    # See [RFC3986](https://tools.ietf.org/html/rfc3986#section-2.3) for the specifications of URL-safe characters
    @url_safe_chars "0-9A-Za-z\-._~"
    use Croma.SubtypeOfString, pattern: ~r"\A[#{@url_safe_chars}]+\Z"
  end
  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    title:             Title,
    body:              Body,
    user_id:           StackoverflowCloneA.DodaiId,
    like_voter_ids:    VoterIdList,
    dislike_voter_ids: VoterIdList,
    comments:          CommentList,
    tags:              TagList,
  ]
end