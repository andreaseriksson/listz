defmodule ListzWeb.ListControllerTest do
  use ListzWeb.ConnCase
  import Listz.TestDataSetup

  alias Listz.Lists

  @create_attrs %{description: "some description", slug: "some slug", title: "some title"}
  @update_attrs %{description: "some updated description", slug: "some updated slug", title: "some updated title"}
  @invalid_attrs %{description: nil, slug: nil, title: nil}

  describe "index as not logged in" do
    test "GET /", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :index))
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "index" do
    setup [:login]

    test "lists all lists", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Lists"
    end
  end

  describe "create list as not logged in" do
    test "redirects to login", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), list: @create_attrs)

      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "create list" do
    setup [:login]

    test "redirects to show when data is valid", %{conn: conn} do
      request = post(conn, Routes.list_path(conn, :create), list: @create_attrs)

      assert %{id: id} = redirected_params(request)
      assert redirected_to(request) == Routes.list_path(conn, :show, id)

      conn = get(conn, Routes.list_path(conn, :show, id))
      assert html_response(conn, 200) =~ @create_attrs[:title]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), list: @invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "show list" do
    setup [:login, :create_list]

    test "renders list page", %{conn: conn, list: list} do
      conn = get(conn, Routes.list_path(conn, :show, list.slug))
      assert html_response(conn, 200) =~ "Listing Tasks"
    end
  end

  describe "update list as not logged in" do
    setup [:create_list]

    test "redirects to login", %{conn: conn, list: list} do
      conn = put(conn, Routes.list_path(conn, :update, list.slug), list: @update_attrs)

      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "update list" do
    setup [:login, :create_list]

    test "redirects when data is valid", %{conn: conn, list: list} do
      conn = put(conn, Routes.list_path(conn, :update, list.slug), list: @update_attrs)
      list = Lists.get_list!(list.id)
      assert redirected_to(conn) == Routes.list_path(conn, :show, list.slug)
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = put(conn, Routes.list_path(conn, :update, list.slug), list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit List"
    end
  end

  describe "delete list as not logged in" do
    setup [:create_list]

    test "redirects to login", %{conn: conn, list: list} do
      conn = delete(conn, Routes.list_path(conn, :delete, list.slug))

      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "delete list" do
    setup [:login, :create_list]

    test "deletes chosen list", %{conn: conn, list: list} do
      request = delete(conn, Routes.list_path(conn, :delete, list.slug))
      assert redirected_to(request) == Routes.list_path(conn, :index)
      assert Lists.list_lists() == []
    end
  end
end
