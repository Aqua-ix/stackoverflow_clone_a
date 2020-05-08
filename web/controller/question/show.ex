use Croma
defmodule StackoverflowCloneA.Controller.Question.Show do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Controller.Question.Helper
  def show(%Conn{request: %Request{path_matches: %{id: id}}} = conn) do
    res = RQ.retrieve(id, StackoverflowCloneA.Dodai.root_key())
    #IO.inspect(res)
    #IO.inspect(elem(res, 1))
    #Helper.to_response_body(elem(res, 1)) |> IO.inspect()
    case res do
      # Questionの取得に成功した場合は、第3引数で指定された関数を実行します。
      {:ok, question}  -> Conn.json(conn, 200, Helper.to_response_body(question))
      # Questionの取得に失敗した場合は、エラーを返します。
      {:error, _}      -> ErrorJson.json_by_error(conn, StackoverflowCloneA.Error.ResourceNotFound.new())
    end
  end
end
#.connからユーザが指定したquestionのidを抜き出す
    #2.このidをもとにdodaiからquestion documentを取得
    #3. question document少し変換(下記関数)してブラウザにレスポンスとして返す
    # web/controller/question/helper.ex の to_response_body/1関数で変換



