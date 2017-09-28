defmodule ExApiWeb.ErrorView do
  use ExApiWeb, :view

  def render("404.html", %{user: user_id, bm: bookmark_id}) do
    "User or bookmark with ids #{user_id}, #{bookmark_id} are not available"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
