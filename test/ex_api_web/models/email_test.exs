defmodule ExApiWeb.EmailTest do
  use ExApiWeb.ConnCase, async: true

  alias ExApiWeb.Email

  @email "johndoe@gmail.com"
  @url "http://www.coursera.org"

  test "creates new email" do
      email = Email.compose_email(%{email: @email}, %{url: @url, description: ""})

      assert email.to == @email
      assert email.from == @email
      assert email.text_body =~ @url
  end
end