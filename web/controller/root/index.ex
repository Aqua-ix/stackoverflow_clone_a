use Croma

defmodule StackoverflowCloneA.Controller.Root.Index do
  use StackoverflowCloneA.Controller.Application

  defun index(conn :: Conn.t) :: Conn.t do
    Conn.render(conn, 200, "root/index", [])
  end
end
