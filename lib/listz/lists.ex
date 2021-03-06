defmodule Listz.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias Listz.Repo

  alias Listz.Lists.List
  alias Listz.Tasks.Task

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists do
    List
    |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id)

  @doc """
  Gets a single list by slug.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list_by_slug!(123)
      %List{}

      iex> get_list_by_slug!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list_by_slug!(slug), do: Repo.get_by!(List, slug: slug)


  @doc """
  Preloads the tasks association on a single or a list of lists.

  ## Examples

      iex> with_tasks(list)
      %List{tasks: []}

      iex> with_tasks([list])
      [%List{tasks: []}]

  """
  def with_tasks(list_or_lists) do
    list_or_lists
    |> Repo.preload([tasks: (from t in Task, order_by: [asc: :completed, desc: :id])])
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers()
  end

  @doc """
  Deletes a List.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
    |> notify_subscribers()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{source: %List{}}

  """
  def change_list(%List{} = list) do
    List.changeset(list, %{})
  end

  @topic inspect(__MODULE__)
  def subscribe do
    Phoenix.PubSub.subscribe(Listz.PubSub, @topic)
  end

  defp notify_subscribers(data) do
    Phoenix.PubSub.broadcast(Listz.PubSub, @topic, {__MODULE__, :lists_updated})
    data
  end
end
