defmodule StackoverflowCloneA.Controller.User.ProxyTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.TestData.UserData

  @user       UserData.dodai()
  @api_prefix "/v1/user/"
  @header     %{"authorization" => "user_credential"}

  test "logout/1 " <>
    "it returns 204" do
    :meck.expect(Sazabi.G2g, :send, fn(_conn) ->
      %Antikythera.G2gResponse{
        body:    "",
        cookies: %{},
        headers: %{},
        status:  204,
      }
    end)

    res = Req.post_json(@api_prefix <> "logout", %{}, @header)
    assert res.status == 204
    assert res.body   == ""
  end

  test "me/1 " <>
    "it returns login user document" do
    :meck.expect(Sazabi.G2g, :send, fn(_conn) ->
      %Antikythera.G2gResponse{
        body:    @user,
        cookies: %{},
        headers: %{},
        status:  200,
      }
    end)

    res = Req.get(@api_prefix <> "me")
    assert res.status == 200
    assert Poison.decode!(res.body) == UserData.gear()
  end
end
