use Croma

defmodule StackoverflowCloneA.Controller.User.Proxy do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Helper.SazabiProxy

  defun proxy(conn :: v[Conn.t]) :: Conn.t do
    SazabiProxy.proxy(conn,
      fn
        body when is_map(body) -> to_response_body(body)
        body                   -> body
      end
    )
  end

  defunp to_response_body(user :: map) :: map do
    Map.take(user, ["email", "session", "createdAt"]) |> underscore_recursively() |> Map.put("id", user["_id"])
  end

  defunp underscore_recursively(v :: map) :: map do
    underscore_recursively_imp(v)
  end
  defp underscore_recursively_imp(v) when is_map(v) do
    Enum.map(v, fn {k, v} ->
      {Macro.underscore(k), underscore_recursively_imp(v)}
    end)
    |> Enum.into(%{})
  end
  defp underscore_recursively_imp(v) when is_list(v) do
    Enum.map(v, fn item ->
      underscore_recursively_imp(item)
    end)
  end
  defp underscore_recursively_imp(v) do
    v
  end
end
