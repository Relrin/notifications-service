defmodule NotificationsServiceWeb.GroupChannelTest do
  use NotificationsServiceWeb.ChannelCase

  alias NotificationsServiceWeb.PubSubSocket

  test "join/3 is successful" do
    assert {:ok, _, %Phoenix.Socket{}} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("group:123", %{})
  end

  test "join/3 is successful (including user)" do
    assert {:ok, _, pubsub_socket} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("user:1", %{})

    assert {:ok, _, _} = subscribe_and_join(pubsub_socket, "group:123", %{})
  end

  test "handle_info/2 is triggerred for the group broadcast" do
    connect()
    |> broadcast_message("update", %{key: "value"})

    assert {:messages,
      [
        %Phoenix.Socket.Message{
          topic: "group:123",
          event: "update",
          payload: %{key: "value"}
        },
      ]} = Process.info(self(), :messages)
  end

  defp connect() do
    assert {:ok, _, socket} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("group:123", %{})
    socket
  end

  defp broadcast_message(socket, event, payload) do
    assert broadcast_from!(socket, event, payload) == :ok
    socket
  end
end