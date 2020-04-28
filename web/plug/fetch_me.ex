use Croma

defmodule StackoverflowCloneA.Plug.FetchMe do
  alias Antikythera.Conn
  alias StackoverflowCloneA.Helper.ErrorJson
  alias StackoverflowCloneA.Error.InvalidCredential
  alias StackoverflowCloneA.Repo.User, as: RU

  defun fetch(conn :: v[Conn.t], _opts :: any) :: Conn.t do
    authorization = Conn.get_req_header(conn, "authorization")
    case authorization do
      nil -> ErrorJson.json_by_error(conn, InvalidCredential.new())
      _   -> fetch_entity(conn, authorization)
    end
  end

  defunp fetch_entity(conn :: v[Conn.t], key :: v[String.t]) :: Conn.t do
    res = RU.retrieve_self(key)
    case res do
      {:ok, user}    -> Conn.assign(conn, :me, user)
      {:error, body} -> ErrorJson.json_by_error(conn, body)
    end
  end
end
