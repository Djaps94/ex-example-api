defmodule ExApi.UserControllerTest do
  use ExApiWeb.ConnCase

  alias ExApi.User

  @user %{name: "John", email: "doe@gmail.com", password: "pass"}

  setup do
    conn =
      build_conn() |> put_req_header("accept", "application_json")
    %{conn: conn}
  end

  describe "create/2 action" do
    test "creates and renders user", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @user
    end
  end
end