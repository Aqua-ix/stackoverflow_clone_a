defmodule StackoverflowCloneA.Controller.Question.CreateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Model.Question
  alias StackoverflowCloneA.TestData.{QuestionData, UserData}

  @question   QuestionData.model()
  @user       UserData.model()
  @api_prefix "/v1/question/"
  @header     %{"authorization" => "user_credential"}

  describe "create/1 " do
    test "should create question" do
      mock_fetch_me_plug(@user)
    
      :meck.expect(RQ, :insert, fn(data, _key) ->
        assert data == %{
          data: %Question.Data{
            title:             "title",
            body:              "body",
            user_id:           @user._id,
            like_voter_ids:    [],
            dislike_voter_ids: [],
            comments:          [],
            tags:              ["tag1", "tag2"]
          }
        }
        {:ok, @question}
      end)

      res = Req.post_json(@api_prefix, %{"title" => "title", "body" => "body", "tags" => ["tag1", "tag2"]}, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == QuestionData.gear()
    end

    test "should return BadRequestError when request body is invalid" do
      mock_fetch_me_plug(@user)

      invalid_bodies = [
        %{                                       "body" => "body", "tags" => ["tag1", "tag2"]},
        %{"title" => "title",                                      "tags" => ["tag1", "tag2"]},
        %{"title" => String.duplicate("a", 101), "body" => "body", "tags" => ["tag1", "tag2"]},
        %{"title" => "title",                    "body" => String.duplicate("a", 3001), "tags" => ["tag1", "tag2"]},
        %{"title" => "",                         "body" => "body", "tags" => ["tag1", "tag2"]},
        %{"title" => "title",                    "body" => "",     "tags" => ["tag1", "tag2"]},
        %{"title" => "title",                    "body" => "body", "tags" => ["", "tag2"]},
        %{"title" => "title",                    "body" => "body", "tags" => ""},
        %{"title" => "title",                    "body" => "body", "tags" => [String.duplicate("a", 11)]},
      ]
      Enum.each(invalid_bodies, fn body ->
        res = Req.post_json(@api_prefix, body, @header)
        assert res.status              == 400
        assert Jason.decode!(res.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end
  end
end
