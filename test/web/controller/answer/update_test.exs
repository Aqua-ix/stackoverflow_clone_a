defmodule StackoverflowCloneA.Controller.Answer.UpdateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.TestData.AnswerData

  @answer   AnswerData.model()
  @api_prefix "/v1/answer/#{@answer._id}"
  @body       %{"body" => "body"}
  @header     %{"authorization" => "hYniRi3lFlsFVMmERimC"}

  describe "update/1 " do
    test "should update answer" do
      # userを取得する処理をmock
      user = StackoverflowCloneA.TestData.UserData.model()
      mock_fetch_me_plug(user) 
    
      # Answerを取得する処理をmock
      :meck.expect(RA, :retrieve, fn(id, _key) ->
        assert id == @answer._id
        {:ok, @answer}
      end)
    
      # Answerを更新する処理をmock
      :meck.expect(RA, :update, fn(data, id, _key) ->
        assert id == @answer._id
        assert data == %{data: %{"$set" => %{body: "body"}}}
        {:ok, @answer}
      end)
    
      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Jason.decode!(res.body) == AnswerData.gear()
    end

    test "should return ResourceNotFoundError when specified answer is not found" do
      :meck.expect(RA, :retrieve, fn(_id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)
      :meck.expect(RA, :update, fn(_data, _id, _key) -> flunk() end)

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
