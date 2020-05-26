defmodule StackoverflowCloneA.Controller.Question.UpdateTest do
  use StackoverflowCloneA.CommonCase
  #alias StackoverflowCloneA.Model.Question
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.TestData.{QuestionData, UserData}

  @question   QuestionData.model()
  @user       UserData.model()
  @api_prefix "/v1/question/#{@question._id}"
  @body       %{"title" => "title", "tags" => ["tag1", "tag2"]}
  @header     %{"authorization" => "user_credential"}

  describe "update/1 " do
    test "should update question" do
      mock_fetch_me_plug(@user)

      user = StackoverflowCloneA.TestData.UserData.model()
      mock_fetch_me_plug(user) 
    
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}
      end)
    
      :meck.expect(RQ, :update, fn(data, id, _key) ->
        assert id == @question._id
        assert data == %{data: %{"$set" => %{title: "title", tags: ["tag1", "tag2"]}}}
        {:ok, @question}
      end)
    
      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Jason.decode!(res.body) == QuestionData.gear()
    end

    test "should return InvalidCredential when user id is not same as the questioner id." do
      mock_fetch_me_plug(@user)

      user = StackoverflowCloneA.TestData.UserData.model()
      mock_fetch_me_plug(user)
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, other_user_question} = StackoverflowCloneA.Model.Question.Data.new(
          %{
            "title" => "title", 
            "body" => "body",
            "user_id" => "other_user_id", 
            "like_voter_ids" => [], 
            "dislike_voter_ids" => [], 
            "comments" => [],
            "tags" => ["tag1", "tag2"]
          })
        {:ok, %{@question | data: other_user_question}}
      end)

      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status              == 401
      assert Jason.decode!(res.body) == %{
        "code"        => "401-00",
        "description" => "The given credential is invalid.",
        "error"       => "InvalidCredential",
      }
    end

    test "should return ResourceNotFoundError when specified question is not found" do
      mock_fetch_me_plug(@user)
      
      :meck.expect(RQ, :retrieve, fn(_id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)
      :meck.expect(RQ, :update, fn(_data, _id, _key) -> flunk() end)

      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status              == 404
      assert Jason.decode!(res.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end
  end
end
