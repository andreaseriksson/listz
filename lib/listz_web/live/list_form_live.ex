defmodule ListzWeb.ListFormLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  import ListzWeb.ErrorHelpers, only: [error_tag: 2]
  alias ListzWeb.Router.Helpers, as: Routes
  alias Listz.Lists
  alias Listz.Lists.List

  def render(assigns) do
    ~L"""
    <%= form_for @changeset, "#", [phx_change: :validate, phx_submit: :save], fn f -> %>
      <div class="flex">
        <%= text_input f, :title, placeholder: "Add a new list", class: "bg-gray-200 appearance-none border-2 border-t border-b border-l border-gray-200 rounded-l w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-blue-500" %>
        <%= submit "Save", class: "px-4 rounded-r bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 border-2 border-t border-b border-r border-blue-500 hover:border-blue-700" %>
      </div>

      <%= if error_tag(f, :title) != [] do %>
        <div class="text-red-500 text-sm font-bold">
          List title <%= error_tag f, :title %>
        </div>
      <% end %>
    <% end %>
    """
  end

  def mount(%{}, socket) do
    assigns = [
      conn: socket,
      changeset: Lists.change_list(%List{})
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset =
      List.changeset(%List{}, list_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"list" => list_params}, socket) do
    case Lists.create_list(list_params) do
      {:ok, list} ->
        {:stop,
          socket
          |> put_flash(:info, "List created successfully.")
          |> redirect(to: Routes.list_path(ListzWeb.Endpoint, :show, list.slug))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
