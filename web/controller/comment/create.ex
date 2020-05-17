use Croma

defmodule StackoverflowCloneA.Controller.Comment.Create do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.{Question, User}
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.Error.{BadRequest, ResourceNotFound}

  plug StackoverflowCloneA.Plug.FetchMe, :fetch, []

  defmodule RequestBody do
    use Croma.Struct, fields: [
      body: Question.CommentBody,
    ]
  end

  defun create(%Conn{
    request: %Request{path_info: [_, document_type, document_id, _], body: body}, 
    assigns: %{me: %User{_id: user_id}}} = conn) :: Conn.t do

    case RequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequest.new())
      {:ok, validated} ->
        comment = to_create_document(user_id, validated)
        query = %{data: %{"$push" => %{"comments" => comment}}}

        res = case document_type do
          "question" -> 
            RQ.update(query, document_id, StackoverflowCloneA.Dodai.root_key())
          "answer" -> 
            RA.update(query, document_id, StackoverflowCloneA.Dodai.root_key())
        end

        case res do
          {:ok, comment} -> 
            Conn.json(conn, 200, comment)
          {:error, %Dodai.ResourceNotFound{}} -> 
            ErrorJson.json_by_error(conn, ResourceNotFound.new())
        end
    end
    
  end

  defun to_create_document(
    user_id :: v[DodaiId.t],
    req :: v[RequestBody.t]) :: map do 
    %{
      "id"         => RandomString.take(20, :alphanumeric),
      "user_id"    => user_id,
      "body"       => req.body,
      "created_at" => Antikythera.Time.to_iso_timestamp(Antikythera.Time.now())
    }
  end
end
