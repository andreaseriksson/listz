defmodule ListzWeb.ListController do
  use ListzWeb, :controller

  alias Listz.Lists
  alias Listz.Lists.List
  alias Listz.Tasks
  alias Listz.Tasks.Task

  defp get_lists do
    Lists.list_lists() |> Lists.with_tasks()
  end

  def index(conn, _params) do
    changeset = Lists.change_list(%List{})

    render(conn, "index.html", lists: get_lists(), changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Lists.change_list(%List{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list" => list_params}) do
    case Lists.create_list(list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List created successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", lists: get_lists(), changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list =
      Lists.get_list_by_slug!(id)
      |> Lists.with_tasks()

    changeset = Tasks.change_task(%Task{})

    render(conn, "show.html", list: list, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    list = Lists.get_list_by_slug!(id)
    changeset = Lists.change_list(list)
    render(conn, "edit.html", list: list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list_by_slug!(id)

    case Lists.update_list(list, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List updated successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list_by_slug!(id)
    {:ok, _list} = Lists.delete_list(list)

    conn
    |> put_flash(:info, "List deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :index))
  end
end
