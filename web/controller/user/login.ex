use Croma

defmodule StackoverflowCloneA.Controller.User.LoginParams do
  use Croma.Struct, recursive_new?: true, fields: [
    email:    Antikythera.Email,
    password: StackoverflowCloneA.NonEmptyString,
  ]
end

defmodule StackoverflowCloneA.Controller.User.Login do
  use StackoverflowCloneA.Controller.Application
  alias StackoverflowCloneA.Controller.User.LoginParams
  alias StackoverflowCloneA.Repo.User, as: RU
  alias StackoverflowCloneA.Model.User

  defun login(%Conn{request: %Request{body: body}} = conn :: v[Conn.t]) :: Conn.t do
    validate_request(conn, body, LoginParams, fn(conn2, validated_params) ->
      login_action = to_login_action(validated_params)
      case RU.login(login_action, StackoverflowCloneA.Dodai.app_key()) do
        {:ok, user}   -> Conn.json(conn2, 201, to_response_body(user))
        {:error, res} -> ErrorJson.json_by_error(conn2, res)
      end
    end)
  end

  defunp to_login_action(params :: v[LoginParams.t]) :: map do
    %{
      email:    params.email,
      password: params.password,
    }
  end

  defunp to_response_body(user :: v[User.t]) :: map do
    Map.from_struct(user)
    |> Map.take([:email])
    |> Map.merge(%{
      "id"         => user._id,
      "created_at" => StackoverflowCloneA.TimeUtil.to_iso_timestamp_sec(user.created_at),
      "session"    => Map.from_struct(user.session) |> Enum.reject(fn {_, v} -> is_nil(v) end) |> Enum.into(%{}),
    })
  end
end
