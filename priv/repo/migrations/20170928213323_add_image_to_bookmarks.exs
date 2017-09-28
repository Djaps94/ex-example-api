defmodule ExApi.Repo.Migrations.AddImageToBookmarks do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :image, :string
    end
  end
end
