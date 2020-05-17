defmodule StackoverflowCloneA.Controller.Answer.CreateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Model.Answer
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.Model.Answer
  alias StackoverflowCloneA.TestData.{QuestionData, AnswerData, UserData}

  @question   QuestionData.model()
  @answer     AnswerData.model()
  @user       UserData.model()
  @api_prefix "/v1/answer/"
  @header     %{"authorization" => "user_credential"}

  describe "create/1 " do
    test "should create answer" do
      mock_fetch_me_plug(@user)

      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}
      end)

      :meck.expect(RA, :insert, fn(data, _key) ->
        assert data == %{
          data: %Answer.Data{
            body:              "body",
            question_id:       "question_id",
            user_id:           @user._id,
            comments:          [],
          }
        }
        {:ok, @answer}
      end)

      res = Req.post_json(@api_prefix, %{"body" => "body", "question_id" => "question_id"}, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == AnswerData.gear()
    end

    test "should return BadRequestError when request body is invalid" do
      mock_fetch_me_plug(@user)

      invalid_bodies = [
        %{"body" => "body"},
        %{"question_id" => "question_id"},
        %{"question_id" => "question_id", "body" => String.duplicate("a", 3001)},
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

    test "should return ResourceNotFoundError when specific question is not found" do
      mock_fetch_me_plug(@user)

      :meck.expect(RQ, :retrieve, fn(_id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)
      :meck.expect(RA, :update, fn(_data, _id, _key) -> flunk() end)

      res = Req.post_json(@api_prefix, %{"question_id" => "question_id", "body" => "body"}, @header)
      assert res.status              == 404
      assert Jason.decode!(res.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end

  end
end
