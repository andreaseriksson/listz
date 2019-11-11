defmodule Listz.TestDataSetup do
  alias Listz.{Lists, Tasks}

  def fixture(:list) do
    {:ok, list} = Lists.create_list(%{title: "My task list"})
    list
  end

  def fixture(:task, list) do
    {:ok, task} = Tasks.create_task(list, %{content: "Important task"})
    task
  end

  def login %{conn: conn} do
    user = %Listz.Users.User{}
    conn = Pow.Plug.assign_current_user(conn, user, otp_app: :listz)

    {:ok, conn: conn}
  end

  def create_list(_) do
    list = fixture(:list)
    {:ok, list: list}
  end

  def create_task(_) do
    list = fixture(:list)
    task = fixture(:task, list)
    {:ok, list: list, task: task}
  end
end
