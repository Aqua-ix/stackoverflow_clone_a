use Croma

defmodule StackoverflowCloneA.Plug.Cors do
  alias Antikythera.Conn

  defun load(conn :: v[Conn.t], _opts :: any) :: Conn.t do
    conn
    |> Conn.put_resp_headers(%{
      "Access-Control-Allow-Origin"  => "*",
      "Access-Control-Allow-Methods" => "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers" => "Accept, Accept-Language, Content-Language, Content-Type, Authorization",
    })
  end
end
