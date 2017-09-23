defmodule ExApi.BookmarksTest do
  use ExApi.DataCase, async: true

  alias ExApi.Bookmark

  @valid_attrs %{url: "http://www.coursera.org", description: "Description"}
  @invalid_attrs %{}

  test "bookmark with valid attributes" do
    changeset = Bookmark.changeset(%Bookmark{}, @valid_attrs)

    assert changeset.valid?
  end

  test "bookmark with invalid attributes" do
    changeset = Bookmark.changeset(%Bookmark{}, @invalid_attrs)

    refute changeset.valid?
  end

  test "bookmark with missing url" do
    changeset = Bookmark.changeset(%Bookmark{}, %{description: "Desc"})

    refute changeset.valid?
  end
end