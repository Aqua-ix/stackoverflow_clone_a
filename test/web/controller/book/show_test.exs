defmodule StackoverflowCloneA.Controller.Book.ShowTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.TestData.BookData

  @book       BookData.model()
  @api_prefix "/v1/book/#{@book._id}"

  describe "show/1" do
    test "should return a book" do
      :meck.expect(RB, :retrieve, fn(id, _key) ->
        assert id == @book._id
        {:ok, @book}
      end)

      res = Req.get(@api_prefix)
      assert res.status              == 200
      assert Jason.decode!(res.body) == BookData.gear()
    end

    test "should return ResourceNotFoundError when specified book is not found" do
      :meck.expect(RB, :retrieve, fn(_id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res = Req.get(@api_prefix)
      assert res.status              == 404
      assert Jason.decode!(res.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end
  end
end
