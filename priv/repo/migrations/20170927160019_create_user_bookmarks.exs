defmodule ExApi.Repo.Migrations.CreateUserBookmarks do
  use Ecto.Migration

  def change do
    create table(:user_bookmarks, primary_key: false) do
      add :user_id, references(:users, null: false)
      add :bookmark_id, references(:bookmarks, null: false)

      timestamps()
    end

    create index(:user_bookmarks, [:user_id])
    create index(:user_bookmarks, [:bookmark_id])
  end
end
