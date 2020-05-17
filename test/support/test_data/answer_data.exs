defmodule StackoverflowCloneA.TestData.AnswerData do

  if function_exported?(StackoverflowCloneA.Model.Answer, :new, 1) do
    alias StackoverflowCloneA.Model.Answer

    @dodai %{
      "_id"       => "id",
      "owner"     => "_root",
      "sections"  => [],
      "version"   => 0,
      "createdAt" => "2018-02-18T01:01:00+00:00",
      "updatedAt" => "2018-02-18T01:01:00+00:00",
      "data"      => %{
        "body"        => "本文",
        "user_id"     => "user_id",
        "question_id" => "question_id",
        "comments"    => [
          %{
            "id"         => "comment_id1",
            "body"       => "本文1",
            "user_id"    => "user_id",
            "created_at" => "2018-02-19T01:01:00+00:00"
          },
          %{
            "id"         => "comment_id2",
            "body"       => "本文2",
            "user_id"    => "user_id",
            "created_at" => "2018-02-19T01:02:00+00:00"
          }
        ],
      }
    }
    @model Map.merge(StackoverflowCloneA.TestData.Common.datastore_fields(), %{_id: @dodai["_id"], data: @dodai["data"]}) |> Answer.new!()
    @gear  Map.merge(@dodai["data"], %{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})

    def dodai(), do: @dodai
    def model(), do: @model
    def gear(),  do: @gear
  end
end
