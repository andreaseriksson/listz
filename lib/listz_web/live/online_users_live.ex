defmodule ListzWeb.OnlineUsersLive do
  use Phoenix.LiveView

  alias Listz.Presence

  def render(assigns) do
    ~L"""
    <%= for {email, _} <- @users do %>
      <%= if email != @current_user.email do %>
        <span class="text-xs bg-green-200 rounded p-2"><%= email %></span>
      <% end %>
    <% end %>
    """
  end

  def mount(%{user: user}, socket) do
    if connected?(socket) do
      {:ok, _} = Presence.track(self(), "listz:presence", user.email, %{
        email: user.email,
        joined_at: :os.system_time(:seconds)
      })

      Phoenix.PubSub.subscribe(Listz.PubSub, "listz:presence")
    end

    assigns = [
      conn: socket,
      users: %{},
      current_user: user
    ]

    socket =
      socket
      |> assign(assigns)
      |> handle_joins(Presence.list("listz:presence"))

    {:ok, socket}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    socket =
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)

    {:noreply, socket}
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta| _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
  end
end
