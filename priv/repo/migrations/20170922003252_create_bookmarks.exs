defmodule ExApi.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :url, :varchar
      add :description, :text

      timestamps()
    end
  end
end
