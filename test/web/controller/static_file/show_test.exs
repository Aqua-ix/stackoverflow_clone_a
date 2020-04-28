defmodule StackoverflowCloneA.Controller.StaticFile.ShowTest do
  use StackoverflowCloneA.CommonCase

  @files [
    %{
      url:          "/robots.txt",
      content_type: "text/plain",
    },
  ]

  describe "show/1" do
    test "should return static file" do
      Enum.map(@files, fn(%{url: url, content_type: content_type}) ->
        res = Req.get(url)
        file_path = Path.join([__DIR__, "../../../..", "priv/static", url])

        assert res.status                  == 200
        assert res.headers["content-type"] == content_type
        assert res.body                    == File.read!(file_path)
      end)
    end
  end
end
