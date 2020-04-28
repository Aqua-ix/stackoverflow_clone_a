defmodule StackoverflowCloneA.Controller.Book.UpdateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.TestData.BookData

  @book       BookData.model()
  @api_prefix "/v1/book/#{@book._id}"
  @body       %{"title" => "title"}

  describe "update/1" do
    test "should update book" do
      :meck.expect(RB, :update, fn(data, id, _key) ->
        assert id   == @book._id
        assert data == %{data: %{"$set" => %{title: "title"}}}
        {:ok, @book}
      end)

      res = Req.put_json(@api_prefix, @body)
      assert res.status              == 200
      assert Jason.decode!(res.body) == BookData.gear()
    end

    test  "should return BadRequestError when request body is invalid" do
      invalid_bodies = [
        %{"title" => "",                         "author" => "author"},
        %{"title" => String.duplicate("a", 101), "author" => "author"},
        %{"title" => "title",                    "author" => ""},
        %{"title" => "title",                    "author" => String.duplicate("a", 51)},
      ]
      Enum.each(invalid_bodies, fn body ->
        res = Req.put_json(@api_prefix, body)
        assert res.status              == 400
        assert Jason.decode!(res.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end

    test "should return ResourceNotFoundError when specified book is not found" do
      :meck.expect(RB, :update, fn(_data, _id, _key) ->
        {:error, %Dodai.ResourceNotFound{}}
      end)

      res = Req.put_json(@api_prefix, @body)
      assert res.status              == 404
      assert Jason.decode!(res.body) == %{
        "code"        => "404-04",
        "description" => "The resource does not exist in the database.",
        "error"       => "ResourceNotFound",
      }
    end
  end
end
