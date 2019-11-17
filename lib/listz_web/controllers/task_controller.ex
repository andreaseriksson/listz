defmodule ListzWeb.TaskController do
  use ListzWeb, :controller

  alias Listz.Lists
  alias Listz.Tasks

  def create(conn, %{"list_id" => list_id, "task" => task_params}) do
    list = Lists.get_list_by_slug!(list_id)

    case Tasks.create_task(list, task_params) do
      {:ok, _task} ->
        conn
        |> notify_users(list)
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_view(ListzWeb.ListView)
        |> render("show.html", list: Lists.with_tasks(list), changeset: changeset)
    end
  end

  def update(conn, %{"list_id" => list_id, "id" => id, "task" => task_params}) do
    list = Lists.get_list_by_slug!(list_id)
    task = Tasks.get_task!(list, id)

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> notify_users(list)
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_view(ListzWeb.ListView)
        |> render("show.html", list: Lists.with_tasks(list), changeset: changeset)
    end
  end

  def delete(conn, %{"list_id" => list_id, "id" => id}) do
    list = Lists.get_list_by_slug!(list_id)
    task = Tasks.get_task!(list, id)

    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> notify_users(list)
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :show, list.slug))
  end

  defp notify_users(conn, %{slug: slug} = _list) do
    ListzWeb.Endpoint.broadcast "list:#{slug}", "list:updated", %{user_id: conn.assigns.current_user.id}
    conn
  end
end
