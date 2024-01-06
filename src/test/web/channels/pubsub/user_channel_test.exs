defmodule NotificationsServiceWeb.UserChannelTest do
  use NotificationsServiceWeb.ChannelCase
  import ExUnit.CaptureLog

  alias NotificationsServiceWeb.{
    PubSubSocket,
    UserChannel,
  }

  test "join/3 is successful for the correct user" do
    assert {:ok, _, %Phoenix.Socket{}} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("user:1", %{})
  end

  test "join/3 failed for a user that specified to wrong channel" do
    assert capture_log(fn ->
             socket(PubSubSocket, "pubsub_socket:2", %{user_id: 2})
             |> subscribe_and_join("user:1", %{}) == {:error, %{reason: "unauthorized"}}
           end) =~ "[error] #{UserChannel} failed 1 != 2"
  end

  test "handle_info/2 is triggerred for generic broadcasts" do
    connect()
    |> broadcast_message("subscribe", %{topic: "group:123"})

    assert {:messages,
      [
        %Phoenix.Socket.Message{
          topic: "user:1",
          event: "subscribe",
          payload: %{topic: "group:123"}
        },
      ]} = Process.info(self(), :messages)
  end

  defp connect() do
    assert {:ok, _, socket} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("user:1", %{})
    socket
  end

  defp broadcast_message(socket, event, payload) do
    assert broadcast_from!(socket, event, payload) == :ok
    socket
  end
end