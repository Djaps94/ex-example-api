defmodule ExApiWeb.BookmarkView do
  use ExApiWeb, :view

  def render("index.json", %{bookmarks: bookmarks}) do
    %{data: render_many(bookmarks, ExApiWeb.BookmarkView, "bookmark.json")}
  end

  def render("create.json", %{bookmark: bookmark}) do
    %{data: render_one(bookmark, ExApiWeb.BookmarkView, "bookmark.json")}
  end

  def render("search.json", %{bookmarks: bookmarks}) do
    %{data: render_many(bookmarks, ExApiWeb.BookmarkView, "bookmark.json")}
  end

  def render("check.json", %{nums: nums}) do
    %{data: %{letter: nums}}
  end

  def render("bookmark.json", %{bookmark: bookmark}) do
    %{id: bookmark.id, url: bookmark.url, description: bookmark.description}
  end
end