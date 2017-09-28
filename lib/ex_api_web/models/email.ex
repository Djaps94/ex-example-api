defmodule ExApiWeb.Email do
  import Bamboo.Email

  def compose_email(%{email: email}, %{url: url, description: _desc}) do
    new_email()
    |> to(email)
    |> from(email)
    |> subject("About bookmark")
    |> html_body("<h1>Bookmark added</h1>")
    |> text_body("Cool you've just added bookmark with url:#{url}.")
  end
end