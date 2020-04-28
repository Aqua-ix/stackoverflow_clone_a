defmodule StackoverflowCloneA.Controller.Book.CreateTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.Model.Book
  alias StackoverflowCloneA.TestData.BookData

  @book       BookData.model()
  @api_prefix "/v1/book"
  @body       %{"title" => "title", "author" => "author"}

  describe "create/1" do
    test "should create book" do
      :meck.expect(RB, :insert, fn(data, _key) ->
        assert data == %{
          data: %Book.Data{
            title:  "title",
            author: "author",
          }
        }
        {:ok, @book}
      end)

      res = Req.post_json(@api_prefix, @body)
      assert res.status              == 201
      assert Jason.decode!(res.body) == BookData.gear()
    end

    test "should return BadRequestError when request body is invalid" do
      invalid_bodies = [
        %{                                       "author" => "author"},
        %{"title" => "",                         "author" => "author"},
        %{"title" => String.duplicate("a", 101), "author" => "author"},
        %{"title" => "body"},
        %{"title" => "body",                     "author" => ""},
        %{"title" => "body",                     "author" => String.duplicate("a", 51)},
      ]
      Enum.each(invalid_bodies, fn body ->
        res = Req.post_json(@api_prefix, body)
        assert res.status              == 400
        assert Jason.decode!(res.body) == %{
          "code"        => "400-06",
          "description" => "Unable to understand the request.",
          "error"       => "BadRequest",
        }
      end)
    end
  end
end
