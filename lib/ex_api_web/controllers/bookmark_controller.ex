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

  def create(conn, %{"bookmark" => params}) do
    case Repo.insert(Bookmark.changeset(%Bookmark{}, params)) do
      {:ok, bookmark} ->
        conn
        |> put_status(:created)
        |> render("create.json", %{bookmark: bookmark})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ExApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = Repo.get(Bookmark, id)

    if bookmark == nil do
      conn |> send_resp(:unprocessable_entity, "")
    else
      case Repo.delete bookmark do
      {:ok, _struct} ->
        conn
        |> send_resp(:no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ExApiWeb.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end
end