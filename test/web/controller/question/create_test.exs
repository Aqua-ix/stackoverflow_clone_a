defmodule StackoverflowCloneA.Controller.Question.CreateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.TestData.QuestionData
  alias StackoverflowCloneA.Model.Question

  @question   QuestionData.model()
  @api_prefix "/v1/question/"

  test "create/1 " <>
    "should create question" do
      user = StackoverflowCloneA.TestData.UserData.model()
      mock_fetch_me_plug(user) 
    
      :meck.expect(RQ, :insert, fn(data, _key) ->
        assert data == %{
          data: %Question.Data{
            title:             "title",
            body:              "body",
            user_id:           user._id,
            like_voter_ids:    [],
            dislike_voter_ids: [],
            comments:          [],
          }
        }
        {:ok, @question}
      end)

      res = Req.post_json(@api_prefix, %{"title" => "title", "body" => "body"}, %{"authorization" => "hYniRi3lFlsFVMmERimC"})
      assert res.status               == 200
      assert Poison.decode!(res.body) == QuestionData.gear()
  end
end
