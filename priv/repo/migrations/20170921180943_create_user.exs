defmodule ExApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :varchar
      add :email, :varchar
      add :password, :varchar

      timestamps()
    end
  end
end
