defmodule Listz.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :content, :text
      add :completed, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:list_id])
  end
end
