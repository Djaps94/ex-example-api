defmodule ExApiWeb.UserBookmark do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExApiWeb.{User, Bookmark}

  @primary_key false
  schema "user_bookmarks" do
    belongs_to :user, User
    belongs_to :bookmark, Bookmark

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:user_id, :bookmark_id])
    |> validate_required([:user_id, :bookmark_id])
  end
end