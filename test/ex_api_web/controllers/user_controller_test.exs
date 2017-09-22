defmodule ExApi.UserControllerTest do
  use ExApiWeb.ConnCase

  alias ExApi.{User, Repo}

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}
  @user_without_pass %{name: "John", email: "doe@gmail.com"}

  setup do
    conn =
      build_conn() |> put_req_header("accept", "application/json")
    %{conn: conn}
  end

  test "returns all users", %{conn: conn} do
    users = [ User.registration_changeset(%User{}, %{name: "John",
                                                     email: "doe@gmail.com",
                                                     password: "doedoe"}),
              User.registration_changeset(%User{}, %{name: "Jane",
                                                     email: "jane@gmail.com",
                                                     password: "janedoe"})]
    Enum.each(users, &Repo.insert!(&1))
    response = get(conn, user_path(conn, :index)) |> json_response(200)

    expected = %{
      "data" => [
        %{"name" => "John", "email" => "doe@gmail.com", "password" => "doedoe"},
        %{"name" => "Jane", "email" => "jane@gmail.com", "password" => "janedoe"}
      ]
    }

    assert expected == response
  end

  describe "create/2 action" do
    test "creates and renders user", %{conn: conn} do
      response = post(conn, user_path(conn, :create), user: @user)
                 |> json_response(201)

      expected = %{
        "data" => %{"name" => "John", "email" => "doe@gmail.com", "password" => "pass"}
      }

      assert expected == response
      assert Repo.get_by(User, %{name: "John"})
    end

    test "creates and renders when password is not suplied", %{conn: conn} do
      response = post(conn, user_path(conn, :create), user: @user_without_pass)
                 |> json_response(201)

      assert response["data"]["password"]
    end
  end
end