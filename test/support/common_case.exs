defmodule StackoverflowCloneA.CommonCase do
  use ExUnit.CaseTemplate
  using do
    quote do
      @time     {Antikythera.Time, {2017, 7, 20}, {1, 00, 00}, 000}
      @conn     Antikythera.Test.ConnHelper.make_conn()
      @app_id   "a_12345678"
      @group_id "g_12345678"

      setup do
        on_exit(&:meck.unload/0)
      end

      defp mock_fetch_me_plug(me) do
        :meck.expect(StackoverflowCloneA.Plug.FetchMe, :fetch, fn(conn, _opts) ->
          Antikythera.Conn.assign(conn, :me, me)
        end)
      end
    end
  end
end
