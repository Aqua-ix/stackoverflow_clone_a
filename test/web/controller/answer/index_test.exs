defmodule StackoverflowCloneA.Controller.Answer.IndexTest do
  if function_exported?(StackoverflowCloneA.Model.Answer, :new, 1) do
    use StackoverflowCloneA.CommonCase
    alias StackoverflowCloneA.TestData.AnswerData

    @answer   AnswerData.model()
    @api_prefix "/v1/answer"

    describe "index/1" do
      test "should return answers" do
        :meck.expect(StackoverflowCloneA.Repo.Answer, :retrieve_list, fn(query, _key) ->
          assert query == %{sort:  %{"_id" => 1}}
          {:ok, [@answer]}
        end)

        res = Req.get(@api_prefix)
        assert res.status               == 200
        assert Poison.decode!(res.body) == [AnswerData.gear()]
      end
    end
  end
end
