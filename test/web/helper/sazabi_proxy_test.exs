defmodule StackoverflowCloneA.Helper.SazabiProxyTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Dodai
  alias StackoverflowCloneA.Helper.SazabiProxy

  test "proxy/2 " <>
    "should modify path info" do
    :meck.expect(Sazabi.G2g, :send, fn(conn) ->
      assert conn.request.path_info == ["v1", Dodai.app_id(), Dodai.default_group_id(), "user", "logout"]

      %Antikythera.G2gResponse{
        headers: %{},
        cookies: %{},
        status:  204,
        body:    "",
      }
    end)

    conn = put_in(@conn.request.path_info, ["v1", "user", "logout"])
    SazabiProxy.proxy(conn, fn body ->
      assert body == ""
      body
    end)
  end

  test "proxy/2 " <>
    "when G2g.send returns error response " <>
    "it returns error response" do
    :meck.expect(Sazabi.G2g, :send, fn(_conn) ->
      %Antikythera.G2gResponse{
        headers: %{},
        cookies: %{},
        status:  404,
        body:    %{
          code:        "404-04",
          name:        "ResourceNotFound",
          description: "The resource does not exist in the database.",
        },
      }
    end)

    conn1 = put_in(@conn.request.path_info, ["v1", "path"])
    conn2 = SazabiProxy.proxy(conn1, fn _body ->
      assert false
    end)
    assert Poison.decode!(conn2.resp_body) == %{
      "code"        => "404-04",
      "name"        => "ResourceNotFound",
      "description" => "The resource does not exist in the database.",
    }
  end

  test "proxy/2 " <>
    "when G2g.send returns empty string " <>
    "it returns empty string" do
    :meck.expect(Sazabi.G2g, :send, fn(_conn) ->
      %Antikythera.G2gResponse{
        headers: %{},
        cookies: %{},
        status:  204,
        body:    "",
      }
    end)

    conn1 = put_in(@conn.request.path_info, ["v1", "path"])
    conn2 = SazabiProxy.proxy(conn1, fn body ->
      assert body == ""
      body
    end)
    assert conn2.resp_body == ""
  end

  test "proxy/2 " <>
    "when G2g.send returns non-empty string " <>
    "it returns non-empty string" do
    :meck.expect(Sazabi.G2g, :send, fn(_conn) ->
      %Antikythera.G2gResponse{
        headers: %{},
        cookies: %{},
        status:  200,
        body:    %{"foo" => "bar"},
      }
    end)

    conn1 = put_in(@conn.request.path_info, ["v1", "path"])
    conn2 = SazabiProxy.proxy(conn1, fn body ->
      assert body == %{"foo" => "bar"}
      body
    end)
    assert Poison.decode!(conn2.resp_body) == %{"foo" => "bar"}
  end
end
