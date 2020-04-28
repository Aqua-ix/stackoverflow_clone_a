defmodule StackoverflowCloneA.Controller.Question.IndexTest do
  if function_exported?(StackoverflowCloneA.Model.Question, :new, 1) do
    use StackoverflowCloneA.CommonCase
    alias StackoverflowCloneA.TestData.QuestionData

    @question   QuestionData.model()
    @api_prefix "/v1/question"

    describe "index/1" do
      test "should return questions" do
        :meck.expect(StackoverflowCloneA.Repo.Question, :retrieve_list, fn(query, _key) ->
          assert query == %{sort:  %{"_id" => 1}}
          {:ok, [@question]}
        end)

        res = Req.get(@api_prefix)
        assert res.status               == 200
        assert Poison.decode!(res.body) == [QuestionData.gear()]
      end
    end
  end
end
