defmodule Listz.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :content, :string
    field :list_id, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:content, :completed])
    |> validate_required([:content, :completed])
  end
end
