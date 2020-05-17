defmodule StackoverflowCloneA.Controller.Comment.UpdateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.TestData.{QuestionData, AnswerData, UserData}

  @question QuestionData.model()
  @answer   AnswerData.model()
  @user     UserData.model()
  @q_prefix "/v1/question/#{@question._id}/comment/comment_id1"
  @a_prefix "/v1/answer/#{@answer._id}/comment/comment_id1"
  @body     %{"body" => "本文1"}
  @header   %{"authorization" => "user_credential"}

  describe "update/1 " do
    test "should update question comment" do
      mock_fetch_me_plug(@user) 
      
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}  
      end)

      :meck.expect(RQ, :update, fn(data, id, _key) ->
        assert id == @question._id
        assert data == %{data: %{"$set" => %{comments: @question.data.comments}}}
        {:ok, @question}
      end)
      
      res_q = Req.put_json(@q_prefix, @body, @header)
      assert res_q.status               == 200
      assert q_body= Jason.decode!(res_q.body)
      assert q_body["data"]["comments"] == QuestionData.gear()["comments"]
    end

    test "should update answer comment" do
      mock_fetch_me_plug(@user) 

      :meck.expect(RA, :retrieve, fn(id, _key) ->
        assert id == @answer._id
        {:ok, @answer}  
      end)

      :meck.expect(RA, :update, fn(data, id, _key) ->
        assert id == @answer._id
        assert data == %{data: %{"$set" => %{comments: @answer.data.comments}}}
        {:ok, @answer}
      end)

      res_a = Req.put_json(@a_prefix, @body, @header)
      assert res_a.status               == 200
      assert a_body= Jason.decode!(res_a.body)
      assert a_body["data"]["comments"] == QuestionData.gear()["comments"]
    end

    test "should return BadRequest when the question comment request is invalid." do
      mock_fetch_me_plug(@user) 
      
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}  
      end)

      invalid_bodies = [
        %{},
        %{"body" => ""},
        %{"body" => String.duplicate("a", 1001)}
      ]

      Enum.each(invalid_bodies, fn body ->
        res_q = Req.put_json(@q_prefix, body, @header)
        assert res_q.status              == 400
        assert Jason.decode!(res_q.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end

    test "should return BadRequest when the answer comment parameter is invalid." do
      mock_fetch_me_plug(@user) 
      
      :meck.expect(RA, :retrieve, fn(id, _key) ->
        assert id == @answer._id
        {:ok, @answer}  
      end)

      invalid_bodies = [
        %{},
        %{"body" => ""},
        %{"body" => String.duplicate("a", 1001)}
      ]

      Enum.each(invalid_bodies, fn body ->
        res_a = Req.put_json(@a_prefix, body, @header)
        assert res_a.status              == 400
        assert Jason.decode!(res_a.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end

    test "should return InvalidCredential when user id is not same as the question id." do
      invalid_user = Map.put(@user, :_id, "invalid_user_id")
      mock_fetch_me_plug(invalid_user)

      :meck.expect(RQ, :retrieve, fn(_id, _key) ->
        {:ok, @question}
      end)
      :meck.expect(RQ, :update, fn(_data, _id, _key) ->
        {:ok, @question}
      end)

      res_q = Req.put_json(@q_prefix, @body, @header)
      assert res_q.status              == 401
      assert Jason.decode!(res_q.body) == %{
        "code"        => "401-00",
        "description" => "The given credential is invalid.",
        "error"       => "InvalidCredential",
      }
    end

    test "should return InvalidCredential when user id is not same as the answer id." do
      invalid_user = Map.put(@user, :_id, "invalid_user_id")
      mock_fetch_me_plug(invalid_user)

      :meck.expect(RA, :retrieve, fn(_id, _key) ->
        {:ok, @answer}
      end)

      :meck.expect(RA, :update, fn(_data, _id, _key) ->
        {:ok, @answer}
      end)

      res_a = Req.put_json(@a_prefix, @body, @header)
      assert res_a.status              == 401
      assert Jason.decode!(res_a.body) == %{
        "code"        => "401-00",
        "description" => "The given credential is invalid.",
        "error"       => "InvalidCredential",
      }
    end

    test "should return ResourceNotFoundError when specified question is not found" do
      mock_fetch_me_plug(@user) 

      :meck.expect(RQ, :update, fn(_query, _id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res_q = Req.put_json(@q_prefix, @body, @header)
      assert res_q.status              == 404
      assert Jason.decode!(res_q.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end

    test "should return ResourceNotFoundError when specified answer is not found" do
      mock_fetch_me_plug(@user) 

      :meck.expect(RA, :update, fn(_query, _id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res_a = Req.put_json(@a_prefix, @body, @header)
      assert res_a.status              == 404
      assert Jason.decode!(res_a.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end

  end
end
