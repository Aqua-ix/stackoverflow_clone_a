defmodule StackoverflowCloneA.Controller.Answer.ShowTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.TestData.AnswerData

  @answer   AnswerData.model()
  @api_prefix "/v1/answer/#{@answer._id}"

  describe "show/1 " do
    test "it returns answer" do
      # meckをここで設定
      :meck.expect(RA, :retrieve, fn(id, _key) ->
        # retrieve関数に指定されたidがAPIのpathで指定されたidと等しいかを確認。
        assert id == @answer._id
        {:ok, @answer}
      end)

      # requestを送信
      res = Req.get(@api_prefix)
      # http statusを検証
      assert res.status               == 200 # 期待される値を指定してください
      # http response bodyを検証
      assert Jason.decode!(res.body) == AnswerData.gear()
    end
    # 指定してidが間違っていたDodaiからエラーが帰ってきた場合のテスト
    test "should return ResourceNotFoundError when specified answer is not found" do
      :meck.expect(RA, :retrieve, fn(_id, _key) ->
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
