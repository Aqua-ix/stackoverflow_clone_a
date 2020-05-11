defmodule StackoverflowCloneA.Controller.Question.CreateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.TestData.QuestionData
  alias StackoverflowCloneA.Model.Question

  @question   QuestionData.model()
  @api_prefix "/v1/question/"
  @header     %{"authorization" => "hYniRi3lFlsFVMmERimC"}

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

      res = Req.post_json(@api_prefix, %{"title" => "title", "body" => "body"}, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == QuestionData.gear()
  end
  test "should return BadRequestError when request body is invalid" do
    invalid_bodies = [
      %{                                       "body" => "body"},
      %{"title" => "",                         "body" => "body"},
      %{"title" => String.duplicate("a", 101), "body" => "body"},
      %{"title" => "body"},
      %{"title" => "body",                     "body" => ""},
      %{"title" => "body",                     "body" => String.duplicate("a", 3001)},
    ]
    Enum.each(invalid_bodies, fn body ->
      res = Req.post_json(@api_prefix, body, @header)
      IO.inspect(res)
      assert res.status              == 400
      assert Jason.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end
end
