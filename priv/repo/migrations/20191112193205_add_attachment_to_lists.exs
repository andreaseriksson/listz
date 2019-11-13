defmodule Listz.Repo.Migrations.AddAttachmentToLists do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :attachment, :string
    end
  end
end
