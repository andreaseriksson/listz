defmodule Listz.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :description, :string
    field :slug, :string
    field :title, :string

    has_many :tasks, Listz.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> unique_constraint(:title, name: :lists_slug_index)
    |> set_slug()
  end

  defp set_slug(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, "" <> title} -> put_change(changeset, :slug, transform_url(title))
      _ -> changeset
    end
  end

  defp transform_url(title) do
    title
    |> String.downcase()
    |> String.replace(" ", "-")
  end
end
