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

  scope "/api", ExApiWeb do
    pipe_through :api

    resources "/users", UserController, only: [:index, :create] do
      resources "/bookmarks", BookmarkController, only: [:index,
                                                        :create,
                                                        :delete]
    end

    get("/users/:user_id/bookmarks/search", BookmarkController, :search)
    get("/users/:user_id/bookmarks/check", BookmarkController, :check)
  end
end
