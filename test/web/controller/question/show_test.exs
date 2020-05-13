defmodule StackoverflowCloneA.Controller.Question.ShowTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.TestData.QuestionData

  @question   QuestionData.model()
  @api_prefix "/v1/question/#{@question._id}"
  describe "show/1 " do
    test "it returns question" do
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        assert id == @question._id
        {:ok, @question}
      end)

      res = Req.get(@api_prefix)
      assert res.status               == 200
      assert Jason.decode!(res.body) == QuestionData.gear()
    end

    test "should return ResourceNotFoundError when specified question is not found" do
      :meck.expect(RQ, :retrieve, fn(_id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res = Req.get(@api_prefix)
      assert res.status               == 404
      assert Jason.decode!(res.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end
  end
end
