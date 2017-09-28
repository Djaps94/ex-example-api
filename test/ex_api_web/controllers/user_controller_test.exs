defmodule ExApiWeb.UserControllerTest do
  use ExApiWeb.ConnCase
  use Bamboo.Test

  alias ExApiWeb.{User, Bookmark, Email}
  alias ExApi.Repo

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}
  @user_without_pass %{name: "John", email: "doe@gmail.com"}
  @user_with_empty_pass %{name: "John", email: "doe@gmail.com", password: ""}

  setup do
    conn =
      build_conn() |> put_req_header("accept", "application/json")
    %{conn: conn}
  end

  test "returns all users", %{conn: conn} do
    user_one = User.registration_changeset(%User{}, %{name: "John",
                                                      email: "doe@gmail.com",
                                                      password: "doedoe"})
    user_two = User.registration_changeset(%User{}, %{name: "Jane",
                                                      email: "jane@gmail.com",
                                                      password: "janedoe"})

    id_one = Repo.insert!(user_one) |> Map.get(:id)
    id_two = Repo.insert!(user_two) |> Map.get(:id)
    response = get(conn, user_path(conn, :index)) |> json_response(200)

    expected = %{
      "data" => [
        %{"id" => id_one, "name" => "John", "email" => "doe@gmail.com", "password" => "doedoe"},
        %{"id" => id_two, "name" => "Jane", "email" => "jane@gmail.com", "password" => "janedoe"}
      ]
    }

    assert expected == response
  end

  test "creates and renders user", %{conn: conn} do
    response = post(conn, user_path(conn, :create), user: @user)
               |> json_response(201)

    expected = %{"name" => "John", "email" => "doe@gmail.com", "password" => "pass"}

    assert expected == Map.delete(response["data"], "id")
    assert Repo.get_by(User, %{name: "John"})
  end

  test "creates and renders user when password is not suplied", %{conn: conn} do
    response =
      post(conn, user_path(conn, :create), user: @user_without_pass)
      |> json_response(201)

    assert response["data"]["password"]
  end

  test "creates and renders user when password is empty string", %{conn: conn} do
    response =
      post(conn, user_path(conn, :create), user: @user_with_empty_pass)
      |> json_response(201)

    assert response["data"]["password"]
  end

  test "doesn't create and render user when data is invalid", %{conn: conn} do
    response = post(conn, user_path(conn, :create), user: %{}) |> json_response(422)

    assert response["errors"] != %{}
  end

  test "sending email with bookmark data", %{conn: conn} do
    user = Repo.insert!(User.registration_changeset(%User{}, @user))
    bookmark = Repo.insert!(Bookmark.changeset(%Bookmark{},
                                               %{url: "www.google.com",
                                                 description: "Wow, so much wow"
                                                }))
    res = post(conn, user_path(conn, :send, user.id, bookmark.id))

    assert response(res, 200)
    assert_delivered_email Email.compose_email(user, bookmark)
  end

  test "tries to send mail to non existing user", %{conn: conn} do
    res = post(conn, user_path(conn, :send, 0, 0))

    assert response(res, 404)
  end
end