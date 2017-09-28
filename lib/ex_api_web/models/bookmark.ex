defmodule ExApiWeb.Bookmark do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias ExApiWeb.{User, UserBookmark}

  schema "bookmarks" do
    field :url, :string
    field :description, :string
    field :image, ExApiWeb.Uploader.Type
    many_to_many :users, User, join_through: UserBookmark, on_delete: :delete_all

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:url, :description, :image])
    |> validate_required(:url)
    |> cast_attachments(params, [:image])
  end
end