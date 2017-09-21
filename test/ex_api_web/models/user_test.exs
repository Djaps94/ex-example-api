defmodule ExApi.UserTest do
  use ExApi.DataCase, async: true

  alias ExApi.User

  @valid_attributes %{name: "John", email: "johndoe@gmail.com"}
  @invalid_attributes %{}

  test "user with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_attributes)

    assert changeset.valid?
  end

  test "user with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attributes)

    refute changeset.valid?
  end

end