defmodule ExApiWeb.BookmarkControllerTest do
  use ExApiWeb.ConnCase
  import Ecto

  alias ExApiWeb.{Bookmark, User, UserBookmark}
  alias ExApi.Repo

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}
  @bookmark %{url: "http://www.coursera.org", description: "Cool site"}

  setup do
    user = Repo.insert!(User.registration_changeset(%User{}, @user))
    conn =
      build_conn() |> put_req_header("accept", "application/json")
    %{conn: conn, user: user}
  end

  test "returns all user bookmarks", %{conn: conn, user: user} do

    bm_one = Repo.insert!(Bookmark.changeset(%Bookmark{}, @bookmark))
    bm_two = Repo.insert!(Bookmark.changeset(%Bookmark{}, %{url: "www.google.com",
                                                                  description: "Something cool"}))

    user_bookmarks = [UserBookmark.changeset(%UserBookmark{},
                                             %{user_id: user.id, bookmark_id: bm_one.id}),
                      UserBookmark.changeset(%UserBookmark{},
                                             %{user_id: user.id, bookmark_id: bm_two.id})
                     ]
    Enum.each(user_bookmarks, &Repo.insert!(&1))

    response = get(conn, user_bookmark_path(conn, :index, user.id))
    |> json_response(200)

    expected = %{"data" => [
        %{"id" => bm_one.id, "url" => "http://www.coursera.org", "description" => "Cool site"},
        %{"id" => bm_two.id, "url" => "www.google.com", "description" => "Something cool"}
      ]}

    assert expected == response
  end

  test "creates and renders bookmark", %{conn: conn, user: user} do
    bookmark = Map.put(@bookmark, :user_id, user.id)

    response =
      post(conn, user_bookmark_path(conn, :create, user.id), bookmark: bookmark)
      |> json_response(201)

    expected = %{"url" => "http://www.coursera.org", "description" => "Cool site"}

    assert expected == Map.delete(response["data"], "id")
    assert Repo.get_by(Bookmark, %{url: "http://www.coursera.org"})
    assert Repo.get_by(UserBookmark, %{user_id: user.id})
  end

  test "doesn't create bookmark when data is invalid", %{conn: conn, user: user} do
    response =
      post(conn, user_bookmark_path(conn, :create, user.id), bookmark: %{})
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "deletes bookmark", %{conn: conn, user: user} do
    bm = Repo.insert!(Bookmark.changeset(%Bookmark{}, @bookmark))
    Repo.insert(UserBookmark.changeset(%UserBookmark{},
                                       %{user_id: user.id, bookmark_id: bm.id}))

    res = delete(conn, user_bookmark_path(conn, :delete, user.id, bm.id))

    assert response(res, 204)
    refute Repo.get(Bookmark, bm.id)
    refute Repo.get_by(UserBookmark, %{bookmark_id: bm.id})
  end

  test "tries to delete bookmark that doesn't exist", %{conn: conn, user: user} do
    res = delete(conn, user_bookmark_path(conn, :delete, user.id, 1))

    assert response(res, 422)
  end

  test "searches bookmark by url", %{conn: conn, user: user} do
    bm_one = Repo.insert!(Bookmark.changeset(%Bookmark{}, @bookmark))
    bm_two = Repo.insert!(Bookmark.changeset(%Bookmark{}, %{url: "http://www.coursera.org",
                                                          description: "Course site"}))

    user_bookmarks = [UserBookmark.changeset(%UserBookmark{},
                                             %{user_id: user.id, bookmark_id: bm_one.id}),
                      UserBookmark.changeset(%UserBookmark{},
                                             %{user_id: user.id, bookmark_id: bm_two.id})
                     ]
    Enum.each(user_bookmarks, &Repo.insert(&1))
    response =
      get(conn,
          user_bookmark_path(conn, :search, user.id),
          %{url: "http://www.coursera.org", description: ""})
      |> json_response(200)

    expected = %{"data" => [
      %{"id" => bm_one.id, "url" => "http://www.coursera.org", "description" => "Cool site"},
      %{"id" => bm_two.id, "url" => "http://www.coursera.org", "description" => "Course site"}]}

    assert expected == response
  end

  test "searches bookmark by description", %{conn: conn, user: user} do
    bm_one = Repo.insert!(build_assoc(user, :bookmarks, @bookmark))
    bm_two = Repo.insert!(build_assoc(user, :bookmarks, %{url: "http://www.ign.com",
                                                          description: "Cool site"}))

    user_bookmarks = [UserBookmark.changeset(%UserBookmark{},
                                         %{user_id: user.id, bookmark_id: bm_one.id}),
                      UserBookmark.changeset(%UserBookmark{},
                                         %{user_id: user.id, bookmark_id: bm_two.id})
                     ]
    Enum.each(user_bookmarks, &Repo.insert(&1))
    response =
      get(conn,
          user_bookmark_path(conn, :search, user.id),
          %{url: "", description: "Cool site"})
      |> json_response(200)

    expected = %{"data" => [
      %{"id" => bm_one.id, "url" => "http://www.coursera.org", "description" => "Cool site"},
      %{"id" => bm_two.id, "url" => "http://www.ign.com", "description" => "Cool site"}
    ]}

    assert expected == response
  end

  test "checks how many 'a' letter there are in urls", %{conn: conn, user: user} do
    bookmark = Repo.insert!(build_assoc(user, :bookmarks, @bookmark))
    another_bookmark =
      Repo.insert!(build_assoc(user, :bookmarks, %{url: "www.blablablaaa.com",
                                                   description: "Hehe"}))
    response =
      get(conn, user_bookmark_path(conn, :check, user.id, bookmark.id))
      |> json_response(200)
    another_response =
      get(conn, user_bookmark_path(conn, :check, user.id, another_bookmark.id))
      |> json_response(200)

    assert response["data"]["letter"] == 1
    assert another_response["data"]["letter"] == 5
  end

  test "gives copied bookmark to user", %{conn: conn, user: _user} do
    bookmark = Repo.insert!(Bookmark.changeset(%Bookmark{}, @bookmark))
    u = User.registration_changeset(%User{}, %{name: "Jane",
                                               email: "janedoe@gmail.com",
                                               password: "janedoe"})

    new_user = Repo.insert!(u)
    res = post(conn, user_bookmark_path(conn, :copy, new_user.id, bookmark.id))
    new_user |> Repo.preload(:bookmarks)

    assert response(res, 204)
    assert new_user.bookmarks
    assert Repo.get_by(UserBookmark, %{user_id: new_user.id, bookmark_id: bookmark.id})
  end

  test "attaches photo to bookmark", %{conn: conn, user: user} do
    bm = Repo.insert!(Bookmark.changeset(%Bookmark{}, @bookmark))
    Repo.insert(UserBookmark.changeset(%UserBookmark{}, %{user_id: user.id, bookmark_id: bm.id}))
    upload = %Plug.Upload{path: "test/ex_api_web/fixtures/elixir.png", filename: "elixir.png"}
    response =
      put(conn, user_bookmark_path(conn, :attach, user.id, bm.id), image: upload)
      |> json_response(200)

    assert response["data"]["image"]
  end
end