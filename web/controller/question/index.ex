use Croma

defmodule StackoverflowCloneA.Controller.Question.Index do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Controller.Question.Helper
  alias StackoverflowCloneA.Repo.Question, as: RQ
  alias StackoverflowCloneA.Error.BadRequest
  
  defmodule QueryParams do
    use Croma.Struct, fields: [
      user_id:  Croma.TypeGen.nilable(StackoverflowCloneA.DodaiId),
      tags:  Croma.TypeGen.nilable(Croma.String),
    ]
  end

  defun index(%Conn{request: %Request{query_params: query_params}} = conn :: v[Conn.t]) :: Conn.t do
    case QueryParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequest.new())
      {:ok, validated} ->
        query = convert_to_dodai_req_query(validated)
        {:ok, question} = RQ.retrieve_list(query, StackoverflowCloneA.Dodai.root_key())
        Conn.json(conn, 200, Enum.map(question, &Helper.to_response_body(&1)))
    end
  end

  defunpt convert_to_dodai_req_query(params :: v[QueryParams.t]) :: map do
    query =
      Map.from_struct(params)
      |> Enum.reject(fn {_, value} -> is_nil(value) end)
      |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
      |> Map.new()
    %{
      query: query,
      sort:  %{"_id" => 1}
    }
  end
end
