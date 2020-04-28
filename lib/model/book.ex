use Croma

defmodule StackoverflowCloneA.Model.Book do
  @moduledoc """
  Book of StackoverflowCloneA app.
  """

  defmodule Title do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,100}\z/u
  end
  defmodule Author do
    use Croma.SubtypeOfString, pattern: ~R/\A.{1,50}\z/u
  end

  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    title:  Title,
    author: Author,
  ]
end
