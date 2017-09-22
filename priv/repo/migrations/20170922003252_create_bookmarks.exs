defmodule ExApi.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :url, :varchar
      add :description, :text
      add :user_id, references(:users, null: false)

      timestamps()
    end

    create index(:bookmarks, [:user_id])
  end
end
