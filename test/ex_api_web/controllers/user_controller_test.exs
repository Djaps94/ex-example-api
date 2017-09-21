defmodule ExApi.UserControllerTest do
  use ExApiWeb.ConnCase

  alias ExApi.{User, Repo}

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}

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
      conn = get conn, user_path(conn, :index)
    end
  end
end