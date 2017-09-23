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

  def search(conn, %{"user_id" => user_id, "url" => url, "description" => desc}) do
    case {url, desc} do
      {nil, nil} ->
        conn |> send_resp(:unprocessable_entity, "")
      {url, desc} when desc in [nil, ""] ->
        bookmarks =
          (from b in Bookmark,
           where: b.user_id == ^user_id
                  and like(b.url, ^url))
          |> Repo.all
        render(conn, "search.json", %{bookmarks: bookmarks})
      {url, desc} when url in [nil, ""] ->
        bookmarks =
          (from b in Bookmark,
           where: b.user_id == ^user_id
           and like(b.description, ^desc))
          |> Repo.all
        render(conn, "search.json", %{bookmarks: bookmarks})
      {url, desc} ->
        bookmarks =
          (from b in Bookmark,
           where: b.user_id == ^user_id
           and like(b.description, ^desc)
           and like(b.url, ^url))
          |> Repo.all
        render(conn, "search.json", %{bookmarks: bookmarks})
    end
  end

  def check(conn, %{"user_id" => _user_id, "id" => id}) do
    bookmark = Repo.get!(Bookmark, id)
    res =
      Enum.filter(String.graphemes(bookmark.url), fn letter -> letter == <<97>> end)
    |> Enum.count
    render(conn, "check.json", %{nums: res})
  end
end