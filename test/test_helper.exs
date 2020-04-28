Antikythera.Test.Config.init()
Antikythera.Test.GearConfigHelper.set_config(%{
  "root_key" => "rkey_xxx",
  "app_key"  => "akey_xxx",
  "app_id"   => "a_12345678",
  "group_id" => "g_12345678",
})

defmodule Req do
  use Antikythera.Test.HttpClient
end

defmodule Socket do
  use Antikythera.Test.WebsocketClient
end

Code.load_file("test/support/common_case.exs")
test_data_dir = "test/support/test_data/"
Code.load_file("test/support/test_data_common.exs")
File.ls!(test_data_dir) |> Enum.sort() |> Enum.each(&Code.load_file(test_data_dir <> &1))
