defmodule ExApi.BookmarksTest do
  use ExApi.DataCase, async: true

  alias ExApi.Bookmarks

  @valid_attrs %{url: "http://www.coursera.org", description: "Description"}
  @invalid_attrs %{}

  test "bookmark with valid attribute" do
    changeset = Bookmarks.changeset(%Bookmarks{}, @valid_attrs)

    assert changeset.valid?
  end
end