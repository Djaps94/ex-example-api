defmodule ExApiWeb.Router do
  use ExApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env == :dev do
      forward("/send_mails", Bamboo.EmailPreviewPlug)
  end

  scope "/api", ExApiWeb do
    pipe_through :api

    resources "/users", UserController, only: [:index, :create] do
      resources "/bookmarks", BookmarkController, only: [:index,
                                                         :create,
                                                         :delete]
      get("/bookmarks/search", BookmarkController, :search)
      get("/bookmarks/check/:id", BookmarkController, :check)
      post("/bookmarks/copy/:id", BookmarkController, :copy)
      put("/bookmarks/attach/:id", BookmarkController, :attach)
    end
    post("/users/:user_id/send/:bookmark_id", UserController, :send)
  end
end
