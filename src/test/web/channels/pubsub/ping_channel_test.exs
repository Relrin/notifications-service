defmodule NotificationsServiceWeb.PingChannelTest do
  use NotificationsServiceWeb.ChannelCase

  alias NotificationsServiceWeb.PubSubSocket

  test "join/3 is successful" do
    assert {:ok, _, %Phoenix.Socket{}} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("ping", %{})
  end

  test "a pong response is returned to the client" do
    assert {:ok, _, socket} =
               socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
               |> subscribe_and_join("ping", %{})

      ref = push(socket, "ping", %{})
      reply = %{ping: "pong"}
      assert_reply ref, :ok, ^reply
  end
end