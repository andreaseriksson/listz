defmodule ListzWeb.ListFormLiveTest do
  use ListzWeb.ConnCase
  import Phoenix.LiveViewTest
  import Listz.TestDataSetup

  alias ListzWeb.ListFormLive

  # @create_attrs %{description: "some description", slug: "some slug", title: "some title"}
  # @update_attrs %{description: "some updated description", slug: "some updated slug", title: "some updated title"}
  # @invalid_attrs %{description: nil, slug: nil, title: nil}
  #
  describe "mounted" do
    setup [:login]

    test "shows the form", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :index))

      assert html = html_response(conn, 200)
      assert html =~ "Add a new list"
    end
  end

  describe "form validation" do
    test "shows validation error when invalid", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, ListFormLive, session: %{})

      form = %{"list" => %{title: "some description"}}
      render_change(view, "validate", form)

      form = %{"list" => %{title: ""}}
      html = render_change(view, "validate", form)

      assert html =~ "can&apos;t be blank"
    end

    test "shows no validation error when valid", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, ListFormLive, session: %{})

      form = %{"list" => %{title: "some description"}}
      html = render_change(view, "validate", form)

      refute html =~ "can&apos;t be blank"
    end
  end

  describe "form submission" do
    test "when valid it redirects to show page", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, ListFormLive, session: %{})

      form = %{"list" => %{title: "some description"}}
      assert {:error, {:redirect, %{to: "/lists/some-description"}}} = render_submit(view, "save", form)
    end

    test "when invalid it redirects to show page", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, ListFormLive, session: %{})

      form = %{"list" => %{title: ""}}
      html = render_submit(view, "save", form)
      assert html =~ "can&apos;t be blank"
    end
  end
end
