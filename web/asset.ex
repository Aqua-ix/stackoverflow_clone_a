defmodule StackoverflowCloneA.Asset do
  use Antikythera.Asset

  if Antikythera.Env.compile_env == :undefined do
    @webpack_dev_server_host_url "http://localhost:8082/priv/static"

    def make_url(path) do
      Path.join(@webpack_dev_server_host_url, path)
    end
  else
    def make_url(path), do: url(path)
  end
end
