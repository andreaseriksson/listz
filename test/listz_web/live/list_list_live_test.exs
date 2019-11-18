defmodule ListzWeb.ListListLiveTest do
  use ListzWeb.ConnCase
  import Phoenix.LiveViewTest
  import Listz.TestDataSetup
  alias ListzWeb.ListListLive

  describe "connected mount" do
    setup [:create_list]

    test "shows the list", %{conn: conn, list: list} do
      {:ok, _view, html} = live_isolated(conn, ListListLive, session: %{})

      assert html =~ list.title
    end
  end

  describe "delete list" do
    setup [:create_list]

    test "shows the result", %{conn: conn, list: list} do
      {:ok, view, _html} = live_isolated(conn, ListListLive, session: %{})
      assert {:error, {:redirect, %{to: "/"}}} = render_click(view, :delete, %{"slug" => list.slug})

      {:ok, _view, html} = live_isolated(conn, ListListLive, session: %{})
      refute html =~ list.title
    end
  end
end
