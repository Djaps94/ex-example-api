defmodule ExApi.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExApi.User

  schema "bookmarks" do
    field :url, :string
    field :description, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:url, :description])
    |> validate_required(:url)
  end
end