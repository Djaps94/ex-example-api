defmodule ExApiWeb.BookmarkView do
  use ExApiWeb, :view

  def render("index.json", %{bookmarks: bookmarks}) do
    %{data: render_many(bookmarks, ExApiWeb.BookmarkView, "bookmark.json")}
  end

  def render("bookmark.json", %{bookmark: bookmark}) do
    %{url: bookmark.url, description: bookmark.description}
  end
end