defmodule ExApiWeb.BookmarkController do
  use ExApiWeb, :controller
  import Ecto.Query

  alias ExApiWeb.Bookmark

  def index(conn, %{"user_id" => user_id}) do
    bookmarks =
      (from b in Bookmark,
      where: b.user_id == ^user_id)
      |> Repo.all
    render(conn, "index.json", %{bookmarks: bookmarks})
  end
end