defmodule ExApiWeb.UserController do
  use ExApiWeb, :controller

  alias ExApi.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, _params) do

  end
end