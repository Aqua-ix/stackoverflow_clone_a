defmodule StackoverflowCloneA.Controller.Question.IndexTest do
  if function_exported?(StackoverflowCloneA.Model.Question, :new, 1) do
    use StackoverflowCloneA.CommonCase
    alias StackoverflowCloneA.TestData.QuestionData

    @question   QuestionData.model()
    @api_prefix "/v1/question"

    describe "index/1" do
      test "should return questions" do
        :meck.expect(StackoverflowCloneA.Repo.Question, :retrieve_list, fn(query, _key) ->
          assert query == %{
            query: %{"data.user_id" => "user_id"},
            sort:  %{"_id" => 1}
          }
          {:ok, [@question]}
        end)

        query = %{"user_id" => "user_id"}
        res = Req.get(@api_prefix <> "?" <> AntikytheraAcs.Test.URIHelper.encode_json_query(query))
        assert res.status               == 200
        assert Poison.decode!(res.body) == [QuestionData.gear()]
      end
    end

    test "should return BadRequest when the request parameter is invalid." do
      invalid_queries = [
        %{"user_id" => "あいうえお"},
        %{"user_id" => "%"}
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
