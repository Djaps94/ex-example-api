defmodule ExApi.User do
  @doc """
  Module represents user data type with name, email and a password,
  which maps to database table of the same name and vica versa.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    has_many :bookmarks, ExApi.Bookmark

    timestamps()
  end

  def registration_changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
  end


end