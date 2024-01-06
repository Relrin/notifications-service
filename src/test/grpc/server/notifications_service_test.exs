defmodule NotificationsServiceGrpc.NotificationsService.ServerTest do
  use NotificationsServiceWeb.ChannelCase
  use ExUnit.Case

  alias NotificationsServiceWeb.PubSubSocket
  alias Notifications.{
    BroadcastTextMessageRequest,
    BroadcastTextMessageResponse,
  }

  setup_all do
    {:ok, channel} = GRPC.Stub.connect("localhost:8080", interceptors: [GRPC.Client.Interceptors.Logger])
    [channel: channel]
  end

  test "broadcast_text_message/2 triggers sending a message to the user", %{channel: channel} do
    assert {:ok, _, %Phoenix.Socket{}} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("user:1", %{})

    req = %BroadcastTextMessageRequest{topics: ["user:1"], event: "subscribe", message: "payload"}
    assert {:ok, %BroadcastTextMessageResponse{}} = Notifications.NotificationsService.Stub.broadcast_text_message(channel, req)

    assert_broadcast "subscribe", _
  end
end