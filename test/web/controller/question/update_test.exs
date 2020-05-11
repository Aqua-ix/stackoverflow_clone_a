defmodule StackoverflowCloneA.Controller.Question.UpdateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.TestData.QuestionData

  @question   QuestionData.model()
  @api_prefix "/v1/question/#{@question._id}"
  @body       %{"title" => "title"}
  @header     %{"authorization" => "hYniRi3lFlsFVMmERimC"}

  describe "update/1 " do
    test "should update question" do
      # userを取得する処理をmock
      user = StackoverflowCloneA.TestData.UserData.model()
      mock_fetch_me_plug(user) 
    
      # Questionを取得する処理をmock
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}
      end)
    
      # Questionを更新する処理をmock
      :meck.expect(RQ, :update, fn(data, id, _key) ->
        assert id == @question._id
        assert data == %{data: %{"$set" => %{title: "title"}}}
        {:ok, @question}
      end)
    
      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Jason.decode!(res.body) == QuestionData.gear()
    end

    test "should return ResourceNotFoundError when specified question is not found" do
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
