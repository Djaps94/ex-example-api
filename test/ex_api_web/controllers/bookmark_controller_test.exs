defmodule ExApiWeb.BookmarkControllerTest do
  use ExApiWeb.ConnCase
  import Ecto

  alias ExApiWeb.{Bookmark, User}
  alias ExApi.Repo

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}
  @bookmark %{url: "http://www.coursera.org", description: "Description"}

  setup do
    user = Repo.insert!(User.registration_changeset(%User{}, @user))
    conn =
      build_conn() |> put_req_header("accept", "application/json")
    %{conn: conn, user: user}
  end

  test "returns all user bookmarks", %{conn: conn, user: user} do

    bookmark_one = build_assoc(user, :bookmarks, @bookmark)
    bookmark_two = build_assoc(user, :bookmarks, %{url: "www.google.com",
                                                  description: "Something cool"})
    Repo.insert!(bookmark_one)
    Repo.insert!(bookmark_two)
    response = get(conn, user_bookmark_path(conn, :index, user.id))
    |> json_response(200)

    expected = %{"data" => [
        %{"url" => "http://www.coursera.org", "description" => "Description"},
        %{"url" => "www.google.com", "description" => "Something cool"}
      ]}

    assert expected == response
  end

  test "creates and renders bookmark", %{conn: conn, user: user} do
    bookmark = Map.put(@bookmark, :user_id, user.id)

    response =
      post(conn, user_bookmark_path(conn, :create, user.id), bookmark: bookmark)
      |> json_response(201)

    expected = %{"data" =>
      %{"url" => "http://www.coursera.org", "description" => "Description"}}

    assert expected == response
    assert Repo.get_by(Bookmark, %{url: "http://www.coursera.org"})
  end

  test "doesn't create bookmark when data is invalid", %{conn: conn, user: user} do
    response =
      post(conn, user_bookmark_path(conn, :create, user.id), bookmark: %{})
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "deletes bookmark", %{conn: conn, user: user} do
    bm = Repo.insert!(build_assoc(user, :bookmarks, @bookmark))
    res = delete(conn, user_bookmark_path(conn, :delete, user.id, bm.id))

    assert response(res, 204)
    refute Repo.get(Bookmark, bm.id)
  end

  test "tries to delete bookmark that doesn't exist", %{conn: conn, user: user} do
    res = delete(conn, user_bookmark_path(conn, :delete, user.id, 1))

    assert response(res, 422)
  end
end