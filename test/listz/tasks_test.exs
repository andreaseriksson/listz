defmodule Listz.TasksTest do
  use Listz.DataCase

  alias Listz.Lists
  alias Listz.Tasks

  describe "tasks" do
    alias Listz.Tasks.Task

    @valid_attrs %{completed: true, content: "some content"}
    @update_attrs %{completed: false, content: "some updated content"}
    @invalid_attrs %{completed: nil, content: nil}
    @list_attrs %{description: "some description", title: "some title"}

    def list_fixture do
      {:ok, list} = Lists.create_list(@list_attrs)
      list
    end

    def task_fixture(list, attrs \\ %{}) do
      {:ok, task} =
        list
        |> Tasks.create_task(
          Enum.into(attrs, @valid_attrs)
        )

      task
    end

    setup do
      list = list_fixture()
      task = task_fixture(list)

      {:ok, %{list: list, task: task}}
    end

    test "list_tasks/0 returns all tasks", %{list: list, task: task} do
      assert Tasks.list_tasks(list) == [task]
    end

    test "get_task!/1 returns the task with given id", %{list: list, task: task} do
      assert Tasks.get_task!(list, task.id) == task
    end

    test "create_task/1 with valid data creates a task", %{list: list} do
      assert {:ok, %Task{} = task} = Tasks.create_task(list, @valid_attrs)
      assert task.completed == true
      assert task.content == "some content"
    end

    test "create_task/1 with invalid data returns error changeset", %{list: list} do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(list, @invalid_attrs)
    end

    test "update_task/2 with valid data updates the task", %{task: task} do
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.completed == false
      assert task.content == "some updated content"
    end

    test "update_task/2 with invalid data returns error changeset", %{list: list, task: task} do
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(list, task.id)
    end

    test "delete_task/1 deletes the task", %{list: list, task: task} do
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(list, task.id) end
    end

    test "change_task/1 returns a task changeset", %{task: task} do
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
