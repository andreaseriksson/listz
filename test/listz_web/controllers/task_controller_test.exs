defmodule ListzWeb.TaskControllerTest do
  use ListzWeb.ConnCase
  import Listz.TestDataSetup

  alias Listz.Tasks

  @create_attrs %{content: "Important task"}
  @update_attrs %{completed: true}
  @invalid_attrs %{content: nil}

  describe "create task as not logged in" do
    setup [:create_list]

    test "redirects to login", %{conn: conn, list: list} do
      conn = post(conn, Routes.list_task_path(conn, :create, list.slug), task: @create_attrs)

      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "create task" do
    setup [:login, :create_list]

    test "redirects to list when data is valid", %{conn: conn, list: list} do
      request = post(conn, Routes.list_task_path(conn, :create, list.slug), task: @create_attrs)

      assert %{id: id} = redirected_params(request)
      assert redirected_to(request) == Routes.list_path(conn, :show, id)

      conn = get(conn, Routes.list_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Important task"
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = post(conn, Routes.list_task_path(conn, :create, list.slug), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "update task as not logged in" do
    setup [:create_task]

    test "redirects to login", %{conn: conn, list: list, task: task} do
      conn = put(conn, Routes.list_task_path(conn, :update, list.slug, task), task: @update_attrs)

      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "update task" do
    setup [:login, :create_task]

    test "redirects when data is valid", %{conn: conn, list: list, task: task} do
      conn = put(conn, Routes.list_task_path(conn, :update, list.slug, task), task: @update_attrs)

      assert redirected_to(conn) == Routes.list_path(conn, :show, list.slug)
      assert %{completed: true} = Tasks.get_task!(list, task.id)
    end
  end

  describe "delete task as not logged in" do
    setup [:create_task]

    test "redirects to login", %{conn: conn, list: list, task: task} do
      conn = delete(conn, Routes.list_task_path(conn, :delete, list.slug, task))

      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "delete list" do
    setup [:login, :create_task]

    test "deletes chosen list", %{conn: conn, list: list, task: task} do
      request = delete(conn, Routes.list_task_path(conn, :delete, list.slug, task))

      assert redirected_to(request) == Routes.list_path(conn, :show, list.slug)

      conn = get(conn, Routes.list_path(conn, :show, list.slug))
      refute html_response(conn, 200) =~ "Important task"
    end
  end
end

