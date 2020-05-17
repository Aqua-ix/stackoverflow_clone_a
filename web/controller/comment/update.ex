use Croma

defmodule StackoverflowCloneA.Controller.Comment.Update do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Model.{Question, User}
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Repo.Answer, as: RA
  alias StackoverflowCloneA.Error.{BadRequest, ResourceNotFound, InvalidCredential}

  plug StackoverflowCloneA.Plug.FetchMe, :fetch, []

  defmodule RequestBody do
    use Croma.Struct, fields: [
      body: Question.CommentBody,
    ]
  end

  defun update(%Conn{
    request: %Request{path_info: [_, document_type, document_id, _, comment_id], body: body}, 
    assigns: %{me: %User{_id: user_id}}} = conn) :: Conn.t do
      with_document(conn, document_type, document_id, fn document ->
        case RequestBody.new(body) do
          {:error, _}      ->
            ErrorJson.json_by_error(conn, BadRequest.new())
          {:ok, validated} ->
            update_comments(conn, document, comment_id, user_id, validated, fn comments -> 
              query = %{data: %{"$set" => %{comments: comments}}}
              repo = get_repo(document_type) 
              res = repo.update(query, document_id, StackoverflowCloneA.Dodai.root_key())

              case res do
                {:ok, comment} -> 
                  Conn.json(conn, 200, comment)
                {:error, _} -> 
                  ErrorJson.json_by_error(conn, ResourceNotFound.new())
              end
            end)
        end
      end)
  end

  defunp with_document(
    conn :: v[Conn.t], 
    type :: v[String.t], 
    id :: v[DodaiId.t], 
    f :: ((map) -> Conn.t)) :: Conn.t do
    res = get_repo(type).retrieve(id, StackoverflowCloneA.Dodai.root_key())
    case res do
      {:ok, document}  -> f.(document)
      {:error, _}      -> ErrorJson.json_by_error(conn, ResourceNotFound.new())
    end
  end
  
  defunp update_comments(
    conn :: v[Conn.t], 
    document :: v[map], 
    comment_id :: v[String.t], 
    user_id :: v[DodaiId.t],
    req :: v[RequestBody.t],
    f :: ((list) -> Conn.t)) :: Conn.t do
      comments = document.data.comments
      index = Enum.find_index(comments, fn(comment) ->
          comment.id == comment_id 
        end)
      if is_nil(index) do
        ErrorJson.json_by_error(conn, ResourceNotFound.new())
      else 
        comment = Enum.at(comments, index)
        if comment.user_id == user_id do
          updated = Map.put(comment, :body, req.body)
          f.(List.replace_at(comments, index, updated))
        else 
          ErrorJson.json_by_error(conn, InvalidCredential.new())
        end 
      end
  end

  def get_repo(type) do
    case type do
      "question" -> 
        RQ
      "answer" -> 
        RA
    end
  end
end
