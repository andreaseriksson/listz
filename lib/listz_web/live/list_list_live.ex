defmodule ListzWeb.ListListLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Link, only: [link: 2]
  alias ListzWeb.Router.Helpers, as: Routes
  alias Listz.Lists

  def render(assigns) do
    ~L"""
    <%= for list <- @lists do %>
      <div class="flex mb-2">
        <div class="flex-1">
          <%= link list.title, to: Routes.list_path(@conn, :show, list.slug) %>
          <span class="ml-2 text-sm text-gray-600">(<%= Enum.count(list.tasks) %> tasks)</span>
        </div>
        <div class="">
          <%= link "Delete", to: "#", phx_click: "delete",  phx_value_slug: list.slug, data: [confirm: "Are you sure?"], class: "text-blue-600" %>
        </div>
      </div>
    <% end %>
    """
  end

  def mount(%{}, socket) do
    Lists.subscribe

    assigns =
      if connected?(socket) do
        [
          conn: socket,
          lists: Lists.list_lists() |> Lists.with_tasks()
        ]
      else
        [conn: socket, lists: []]
      end

    {:ok, assign(socket, assigns)}
  end

  def handle_event("delete", %{"slug" => slug}, socket) do
    list = Lists.get_list_by_slug!(slug)
    {:ok, _list} = Lists.delete_list(list)

    response =
      socket
      |> put_flash(:info, "List deleted successfully.")
      |> redirect(to: Routes.list_path(ListzWeb.Endpoint, :index))

    {:stop, response}
  end

  def handle_info({Lists, _}, socket) do
    assigns = [
      lists: Lists.list_lists() |> Lists.with_tasks()
    ]

    {:noreply, assign(socket, assigns)}
  end
end
