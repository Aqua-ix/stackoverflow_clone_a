defmodule StackoverflowCloneA.Controller.Question.ShowTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.TestData.QuestionData

  @question   QuestionData.model()
  @api_prefix "/v1/question/#{@question._id}"
  # 正常系のテスト
  describe "show/1 " do
    test "it returns question" do
      # meckをここで設定
      :meck.expect(RQ, :retrieve, fn(id, _key) ->
        # retrieve関数に指定されたidがAPIのpathで指定されたidと等しいかを確認。
        assert id == @question._id
        {:ok, @question}
        # 成功時のresponseをここで返してあげましょう
      end)

      # requestを送信
      res = Req.get(@api_prefix)
      # http statusを検証
      assert res.status               == 200 # 期待される値を指定してください
      # http response bodyを検証
      assert Jason.decode!(res.body) == QuestionData.gear()
    end

    # 指定してidが間違っていたDodaiからエラーが帰ってきた場合のテスト
    test "should return ResourceNotFoundError when specified question is not found" do
      :meck.expect(RQ, :retrieve, fn(_id, _key) ->
        # エラー時のresponseをここで返してあげましょう
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res = Req.get(@api_prefix)
      assert res.status               == 404 # 期待される値を指定してください
      # response bodyがエラーとなっていることを検証
      assert Jason.decode!(res.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end
  end
end
