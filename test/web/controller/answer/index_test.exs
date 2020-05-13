defmodule StackoverflowCloneA.Controller.Answer.IndexTest do
  if function_exported?(StackoverflowCloneA.Model.Answer, :new, 1) do
    use StackoverflowCloneA.CommonCase
    alias StackoverflowCloneA.TestData.AnswerData

    @answer   AnswerData.model()
    @api_prefix "/v1/answer"

    describe "index/1" do
      test "should return answers" do
        :meck.expect(StackoverflowCloneA.Repo.Answer, :retrieve_list, fn(query, _key) ->
          assert query == %{
            query: %{"data.user_id" => "user_id", "data.question_id" => "question_id"},
            sort:  %{"_id" => 1}
          }
          {:ok, [@answer]}
        end)

        query = %{"user_id" => "user_id", "question_id" => "question_id"}
        res = Req.get(@api_prefix <> "?" <> AntikytheraAcs.Test.URIHelper.encode_json_query(query))
        assert res.status               == 200
        assert Poison.decode!(res.body) == [AnswerData.gear()]
      end
    end

    test "should return BadRequest when the request parameter is invalid." do
      invalid_queries = [
        %{"user_id" => "あいうえお", "question_id" => "あいうえお"},
        %{"user_id" => "%", "question_id" => "%"},
      ]
      Enum.each(invalid_queries, fn query ->
        res = Req.get(@api_prefix <> "?" <> AntikytheraAcs.Test.URIHelper.encode_json_query(query))
        assert res.status               == 400
        assert Jason.decode!(res.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end
  end
end
