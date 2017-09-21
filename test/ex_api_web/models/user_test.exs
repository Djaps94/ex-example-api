defmodule ExApi.UserTest do
  use ExApi.DataCase

  alias ExApi.User

  @valid_attributes %{name: "John", email: "johndoe@gmail.com"}
  @invalid_attributes %{}

  test "user with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attributes)

    assert changeset.valid?
  end

end