defmodule ExApi.UserTest do
  use ExApi.DataCase, async: true

  alias ExApi.User

  @valid_attributes %{name: "John", email: "johndoe@gmail.com"}
  @invalid_attributes %{}
  @invalid_email %{email: "something.email.com"}

  test "user with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_attributes)

    assert changeset.valid?
  end

  test "user with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attributes)

    refute changeset.valid?
  end

  test "user with wrong format of email" do
    changeset = User.registration_changeset(%User{}, @invalid_email)

    {error_message, _} = changeset.errors[:email]

    assert error_message == "has invalid format"
    refute changeset.valid?
  end

  test "user with missing name" do
    changeset = User.registration_changeset(%User{},
                                            %{email: "johndoe@gmail.com",
                                              password: "doedoe"
                                            })
    {error_message, _} = changeset.errors[:name]

    assert error_message == "can't be blank"
    refute changeset.valid?
  end

  test "user with missing email" do
    changeset = User.registration_changeset(%User{}, %{name: "John",
                                                       password: "DoeDoe"})
    {error_message, _} = changeset.errors[:email]

    assert error_message == "can't be blank"
    refute changeset.valid?
  end

end