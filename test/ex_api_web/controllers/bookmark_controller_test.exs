defmodule ExApiWeb.BookmarkControllerTest do
  use ExApiWeb.ConnCase

  alias ExApiWeb.Bookmark
  alias ExApi.Repo

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}
  @bookmark %{url: "http://www.coursera.org", description: "Description"}

  setup do
    conn =
      build_conn() |> put_req_header("accept", "application/json")
    %{conn: conn}
  end

  test "returns all user bookmarks" do
    user = Repo.insert!(@user)
    bookmark = Repo.build_assoc(post, :bookmarks, @bookmark)
    Repo.insert!(bookmark)

    get(conn, user_bookmark_path(conn, :index)) |> json_response(200)
  end
end