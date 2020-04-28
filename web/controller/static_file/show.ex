use Croma

defmodule StackoverflowCloneA.Controller.StaticFile.Show do
  use StackoverflowCloneA.Controller.Application

  defun show(%Conn{request: %Request{path_info: path_info}} = conn) :: Conn.t do
    path = Path.join(["static" | path_info])
    Conn.send_priv_file(conn, 200, path)
  end
end
