defmodule Listz.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :slug, :string
      add :description, :text

      timestamps()
    end

    create index(:lists, [:slug])
  end
end
