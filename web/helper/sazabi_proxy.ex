use Croma

defmodule StackoverflowCloneA.Helper.SazabiProxy do
  use Antikythera.Controller
  alias Antikythera.{Conn, Request}
  alias StackoverflowCloneA.Dodai

  defun proxy(conn :: v[Conn.t], f :: ((map | [map] | String.t) -> Conn.t)) :: Conn.t do
    res = set_path_info(conn) |> Sazabi.G2g.send()
    case res do
      %{status: status, body: body} when status >= 200 and status < 300 ->
        case f.(body) do
          ""         -> Conn.put_status(conn, status)
          fixed_body -> Conn.json(conn, status, fixed_body)
        end
      %{status: error_status, body: error_body} ->
        Conn.json(conn, error_status, error_body)
    end
  end

  defunp set_path_info(%Conn{request: %Request{path_info: ["v1" | tail]}} = conn:: v[Conn.t]) :: Conn.t do
    put_in(conn.request.path_info, ["v1", Dodai.app_id(), Dodai.default_group_id() | tail])
  end
end
