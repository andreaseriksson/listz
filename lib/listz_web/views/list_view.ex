defmodule ListzWeb.ListView do
  use ListzWeb, :view

  alias Listz.Tasks

  def task_changeset(task), do: Tasks.change_task(task)
end
