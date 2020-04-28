defmodule StackoverflowCloneA.TestData.Common do
  @time             {Antikythera.Time, {2018, 2, 18}, {1, 1, 0}, 0}
  @datastore_fields %{
    created_at: @time,
    updated_at: @time,
    owner:      "_root",
    version:    0,
  }

  def datastore_fields(), do: @datastore_fields
end
