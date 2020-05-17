defmodule StackoverflowCloneA.TestData.QuestionData do
  if function_exported?(StackoverflowCloneA.Model.Question, :new, 1) do
    alias StackoverflowCloneA.Model.Question

    @dodai %{
      "_id"       => "question_id",
      "owner"     => "_root",
      "sections"  => [],
      "version"   => 0,
      "createdAt" => "2018-02-18T01:01:00+00:00",
      "updatedAt" => "2018-02-18T01:01:00+00:00",
      "data"      => %{
        "title"    => "タイトル",
        "body"     => "本文",
        "user_id"  => "user_id",
        "comments" => [
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
        "like_voter_ids" => [
          "like_user_id"
        ],
        "dislike_voter_ids" => [
          "dislike_user_id"
        ],
      }
    }

    @model Map.merge(StackoverflowCloneA.TestData.Common.datastore_fields(), %{_id: @dodai["_id"], data: @dodai["data"]}) |> Question.new!()
    @gear  Map.merge(@dodai["data"], %{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})

    def dodai(), do: @dodai
    def model(), do: @model
    def gear(),  do: @gear
  end
end
