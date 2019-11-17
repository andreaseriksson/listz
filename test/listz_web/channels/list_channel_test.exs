defmodule ListzWeb.ListChannelTest do
  use ListzWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      socket(ListzWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(ListzWeb.ListChannel, "list:lobby")

    {:ok, socket: socket}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
