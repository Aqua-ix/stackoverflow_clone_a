defmodule StackoverflowCloneA.Router do
  use Antikythera.Router

  static_prefix "/static"

  get "/", Root.Index, :index
  get "/login", Root.Index, :index
  get "/user/:id", Root.Index, :index
  get "/question/:id", Root.Index, :index
  get "/question/create", Root.Index, :index
  get "/authenticated/sample", Root.Index, :index

  get "/robots.txt",  StaticFile.Show, :show
  get "/favicon.ico", StaticFile.Show, :show

  post "/v1/user/login",  User.Login, :login
  post "/v1/user/logout", User.Proxy, :proxy
  get  "/v1/user/me",     User.Proxy, :proxy

  get  "/v1/question",     Question.Index,  :index
  post "/v1/question",     Question.Create, :create
  get  "/v1/question/:id", Question.Show,   :show
  put  "/v1/question/:id", Question.Update, :update

  get  "/v1/answer",     Answer.Index,  :index
  post "/v1/answer",     Answer.Create, :create
  get  "/v1/answer/:id", Answer.Show,   :show
  put  "/v1/answer/:id", Answer.Update, :update

  post "/v1/question/:document_id/comment",     Comment.Create, :create
  put  "/v1/question/:document_id/comment/:id", Comment.Update, :update
  post "/v1/answer/:document_id/comment",       Comment.Create, :create
  put  "/v1/answer/:document_id/comment/:id",   Comment.Update, :update

  post "/v1/question/:id/vote/like_vote",    Vote.Create, :create
  post "/v1/question/:id/vote/dislike_vote", Vote.Create, :create

  post "/v1/book",     Book.Create, :create
  put  "/v1/book/:id", Book.Update, :update
  get  "/v1/book",     Book.Index,  :index
  get  "/v1/book/:id", Book.Show,   :show
end
