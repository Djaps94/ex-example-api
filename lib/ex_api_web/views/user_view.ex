defmodule ExApiWeb.UserView do
  use ExApiWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, ExApiWeb.UserView, "user.json")}
  end

  def render("create.json", %{user: user}) do
    %{data: render_one(user, ExApiWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email, password: user.password}
  end
end