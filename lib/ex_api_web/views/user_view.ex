defmodule ExApiWeb.UserView do
  use ExApiWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, ExApiWeb.UserView, "users.json")}
  end

  def render("users.json", %{user: user}) do
    %{name: user.name, email: user.email, password: user.password}
  end
end