use Croma

defmodule StackoverflowCloneA.NonEmptyString do
  use Croma.SubtypeOfString, pattern: ~r"\A.+\Z"
end
