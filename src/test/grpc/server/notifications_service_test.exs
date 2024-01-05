defmodule NotificationsServiceGrpc.NotificationsService.ServerTest do
  use NotificationsServiceWeb.ChannelCase
  use ExUnit.Case

  alias NotificationsServiceWeb.PubSubSocket
  alias Notifications.{
    SubscribeRequest,
    SubscribeResponse,
    UnsubscribeRequest,
    UnsubscribeResponse,
    BroadcastTextMessageRequest,
    BroadcastTextMessageResponse,
  }

  setup_all do
    {:ok, channel} = GRPC.Stub.connect("localhost:8080", interceptors: [GRPC.Client.Interceptors.Logger])
    [channel: channel]
  end

  test "subscribe/2 asks a user to subscribe to the topic", %{channel: channel} do
    topics = ["game"]
    user_socket = connect()

    req = %SubscribeRequest{user_ids: ["1"], topics: topics}
    assert {:ok, %SubscribeResponse{}} = Notifications.NotificationsService.Stub.subscribe(channel, req)

    assert_broadcast "subscribe", _
    validate_assigned_topics(user_socket, topics)
  end

  test "unsubscribe/2 asks a user to unsubscribe from the topic", %{channel: channel} do
    topics = ["group"]
    user_socket = connect()

    req = %SubscribeRequest{user_ids: ["1"], topics: topics}
    assert {:ok, %SubscribeResponse{}} = Notifications.NotificationsService.Stub.subscribe(channel, req)

    assert_broadcast "subscribe", _
    validate_assigned_topics(user_socket, topics)

    req = %UnsubscribeRequest{user_ids: ["1"], topics: topics}
    assert {:ok, %UnsubscribeResponse{}} = Notifications.NotificationsService.Stub.unsubscribe(channel, req)

    assert_broadcast "unsubscribe", _
    validate_assigned_topics(user_socket, [])
  end

  test "broadcast_text_message/2 triggers sending a message to the user", %{channel: channel} do
    user_socket = connect()

    req = %SubscribeRequest{user_ids: ["1"], topics: ["group:1"]}
    assert {:ok, %SubscribeResponse{}} = Notifications.NotificationsService.Stub.subscribe(channel, req)

    assert_broadcast "subscribe", _
    validate_assigned_topics(user_socket, ["group:1"])

    req = %BroadcastTextMessageRequest{topic: "group:1", message: "payload"}
    assert {:ok, %BroadcastTextMessageResponse{}} = Notifications.NotificationsService.Stub.broadcast_text_message(channel, req)

    # TODO: Fix broadcasting check
  end

  defp connect() do
    assert {:ok, _, socket} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("user:1", %{})
    socket
  end

  defp validate_assigned_topics(socket, expected_topics) do
    assert :sys.get_state(socket.channel_pid).assigns.topics == expected_topics
    socket
  end
end