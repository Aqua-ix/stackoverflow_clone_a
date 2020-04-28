defmodule StackoverflowCloneA.Controller.Book.IndexTest do
  use StackoverflowCloneA.CommonCase
  alias StackoverflowCloneA.Repo.Book, as: RB
  alias StackoverflowCloneA.Controller.Book.Index
  alias StackoverflowCloneA.Controller.Book.Index.QueryParams
  alias StackoverflowCloneA.TestData.BookData

  @book       BookData.model()
  @api_prefix "/v1/book"

  describe "index/1" do
    test "should return books" do
      :meck.expect(RB, :retrieve_list, fn(query, _key) ->
        assert query == %{
          query: %{},
          sort:  %{"_id" => 1},
        }
        {:ok, [@book]}
      end)

      res = Req.get(@api_prefix)
      assert res.status              == 200
      assert Jason.decode!(res.body) == [BookData.gear()]
    end
  end

  describe "convert_to_dodai_req_query/1" do
    test "should build query" do
      params_list = [
        {%QueryParams{title: nil,     author: nil},      %{query: %{},                                                   sort: %{"_id" => 1}}},
        {%QueryParams{title: "title", author: nil},      %{query: %{"data.title" => "title"},                            sort: %{"_id" => 1}}},
        {%QueryParams{title: nil,     author: "author"}, %{query: %{                         "data.author" => "author"}, sort: %{"_id" => 1}}},
        {%QueryParams{title: "title", author: "author"}, %{query: %{"data.title" => "title", "data.author" => "author"}, sort: %{"_id" => 1}}},
      ]
      Enum.each(params_list, fn {params, expected} ->
        assert Index.convert_to_dodai_req_query(params) == expected
      end)
    end
  end
end
