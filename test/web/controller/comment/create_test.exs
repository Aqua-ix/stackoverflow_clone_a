defmodule StackoverflowCloneA.Controller.Comment.CreateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.TestData.{QuestionData, AnswerData, UserData}

  @question QuestionData.model()
  @answer   AnswerData.model()
  @user     UserData.model()
  @comment  %{
    "id"         => "random_string",
    "user_id"    => "user_id",
    "body"       => "body",
    "created_at" => "created_time",
  }
  @q_prefix "/v1/question/#{@question._id}/comment"
  @a_prefix "/v1/answer/#{@answer._id}/comment"
  @body     %{"body" => "body"}
  @header   %{"authorization" => "user_credential"}
  

  describe "create/1 " do
    test "should create question comment" do
      mock_fetch_me_plug(@user) 
    
      :meck.expect(RQ, :update, fn(data, id, _key) ->
        assert id == @question._id
        assert data == %{data: %{"$push" => %{"comments" => @comment}}}
        {:ok, @question}
      end)

      :meck.expect(RandomString, :take, fn (_, _) -> 
        "random_string"
      end)

      :meck.expect(Antikythera.Time, :to_iso_timestamp, fn (_) -> 
        "created_time"
      end)
      
      res_q = Req.post_json(@q_prefix, @body, @header)
      assert res_q.status               == 200
      assert q_body = Jason.decode!(res_q.body)
      assert q_body["data"]["comments"] == QuestionData.gear()["comments"]
    end

    test "should create answer comment" do
      mock_fetch_me_plug(@user) 

      :meck.expect(RA, :update, fn(data, id, _key) ->
        assert id == @answer._id
        assert data == %{data: %{"$push" => %{"comments" => @comment}}}
        {:ok, @answer}
      end)

      :meck.expect(RandomString, :take, fn (_, _) -> 
        "random_string"
      end)

      :meck.expect(Antikythera.Time, :to_iso_timestamp, fn (_) -> 
        "created_time"
      end)
      
      res_a = Req.post_json(@a_prefix, @body, @header)
      assert res_a.status               == 200
      assert a_body= Jason.decode!(res_a.body)
      assert a_body["data"]["comments"] == AnswerData.gear()["comments"]
    end

    test "should return BadRequest when the question comment request is invalid." do
      mock_fetch_me_plug(@user) 

      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}  
      end)

      invalid_bodies = [
        %{},
        %{"body" => String.duplicate("a", 1001)}
      ]

      Enum.each(invalid_bodies, fn body ->
        res_q = Req.post_json(@q_prefix, body, @header)
        assert res_q.status              == 400
        assert Jason.decode!(res_q.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end

    test "should return BadRequest when the answer comment request is invalid." do
      mock_fetch_me_plug(@user) 

      :meck.expect(RA, :retrieve, fn(id, _key) ->
        assert id == @answer._id
        {:ok, @answer}  
      end)

      invalid_bodies = [
        %{},
        %{"body" => String.duplicate("a", 1001)}
      ]
      
      Enum.each(invalid_bodies, fn body ->
        res_a = Req.post_json(@a_prefix, body, @header)
        assert res_a.status              == 400
        assert Jason.decode!(res_a.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end

    test "should return ResourceNotFoundError when specified question is not found" do
      mock_fetch_me_plug(@user) 

      :meck.expect(RQ, :update, fn(_query, _id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res_q = Req.post_json(@q_prefix, @body, @header)
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

      res_a = Req.post_json(@a_prefix, @body, @header)
      assert res_a.status              == 404
      assert Jason.decode!(res_a.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end
    
  end
end
