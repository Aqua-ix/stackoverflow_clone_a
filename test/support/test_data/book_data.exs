defmodule StackoverflowCloneA.TestData.BookData do
  alias StackoverflowCloneA.Model.Book

  @dodai %{
    "_id"       => "id",
    "owner"     => "_root",
    "sections"  => [],
    "version"   => 0,
    "createdAt" => "2018-02-18T01:01:00+00:00",
    "updatedAt" => "2018-02-18T01:01:00+00:00",
    "data"      => %{
      "title"  => "title",
      "author" => "author",
    }
  }

  @model Map.merge(StackoverflowCloneA.TestData.Common.datastore_fields(), %{_id: @dodai["_id"], data: @dodai["data"]}) |> Book.new!()
  @gear  Map.merge(@dodai["data"], %{"id" => @dodai["_id"]})

  def dodai(), do: @dodai
  def model(), do: @model
  def gear(),  do: @gear
end
