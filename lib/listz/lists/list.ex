defmodule Listz.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :description, :string
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :slug, :description])
    |> validate_required([:title, :slug, :description])
  end
end
