defmodule StackoverflowCloneA.Controller.User.LoginTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.User, as: RU
  alias StackoverflowCloneA.TestData.UserData

  @user       UserData.model()
  @api_prefix "/v1/user/login"
  @header     %{"authorization" => "user_credential"}
  @body       %{
    "email"    => "test.user@example.com",
    "password" => "password",
  }

  test "login/1 " <>
    "it returns user document" do
    :meck.expect(RU, :login, fn(login_action, _key) ->
      assert login_action == %{email: "test.user@example.com", password: "password"}

      {:ok, @user}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 201
    assert Poison.decode!(res.body) == UserData.gear()
  end

  test "login/1 " <>
    "when request body is invalid " <>
    "it returns BadRequest" do
    mock_fetch_me_plug(%{"_id" => "user_id"})
    invalid_bodies = [
      %{},
      %{"email" => "test.user@example.com"},
      %{"email" => "",                      "password" => "password"},
      %{"email" => "test.user@example.com", "password" => ""},
    ]

    Enum.each(invalid_bodies, fn body ->
      res = Req.post_json(@api_prefix, body, @header)
      assert res.status               == 400
      assert Poison.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end

  test "login/1 " <>
    "when dodai returns Unauthorized error " <>
    "it returns Unauthorized error" do
    :meck.expect(RU, :login, fn(_login_action, _key) ->
      {:error, StackoverflowCloneA.Error.Unauthorized.new()}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-01",
      "description" => "The given email, user name and/or password are incorrect.",
      "error"       => "Unauthorized"
    }
  end
end
