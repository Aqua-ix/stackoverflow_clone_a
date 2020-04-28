defmodule StackoverflowCloneA.TestData.UserData do
  alias StackoverflowCloneA.MapUtil
  alias StackoverflowCloneA.Model.User

  @dodai %{
    "_id"            => "user_id",
    "email"          => "test.user@example.com",
    "version"        => 0,
    "sections"       => [],
    "sectionAliases" => [],
    "rulesOfUser"    => [],
    "createdAt"      => "2017-02-10T01:37:49+00:00",
    "updatedAt"      => "2017-02-10T01:37:49+00:00",
    "data"           => %{},
    "readonly"       => %{},
    "rootonly"       => %{},
    "role"           => %{
      "groupWideAdmin" => false,
      "groupAppAdmin"  => false
    },
    "session"        => %{
      "key"               => "xxx",
      "expiresAt"         => "2018-02-27T05:18:43+00:00",
      "passwordSetAt"     => "2018-02-26T05:18:43+00:00",
      "passwordExpiresAt" => "2018-02-26T05:18:43+00:00",
    }
  }

  @model User.new!(@dodai)
  @gear  MapUtil.from_struct_recursively(@model)
        |> MapUtil.stringify_keys()
        |> Map.take(["email", "session"])
        |> Map.merge(%{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})

  def dodai(), do: @dodai
  def model(), do: @model
  def gear(),  do: @gear
end
