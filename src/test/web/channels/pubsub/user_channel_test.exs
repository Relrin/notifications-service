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
    topics = ["game"]

    connect()
    |> broadcast_subscribe_topics(topics)
    |> validate_assigned_topics(topics)
    |> broadcast_message("game", %{message: "update"})

    assert {:messages,
      [
        %Phoenix.Socket.Message{
          event: "game",
          payload: %{message: "update"}
        },
      ]} = Process.info(self(), :messages)
  end

  test "subscribe/3 assigns new topic to listen" do
    topics = ["group:12345", "game"]
    expected_topics = Enum.reverse(topics)

    connect()
    |> broadcast_subscribe_topics(topics)
    |> validate_assigned_topics(expected_topics)
  end

  test "subscribe/3 assigns new topic to listen and avoid duplicates" do
    topics = ["group:12345", "game", "game"]
    expected_topics = Enum.reverse(Enum.dedup(topics))

    connect()
    |> broadcast_subscribe_topics(topics)
    |> validate_assigned_topics(expected_topics)
  end

  test "unsubscribe/3 removes topics" do
    topics = ["group:12345", "game"]
    expected_topics = Enum.reverse(topics)

    connect()
    |> broadcast_subscribe_topics(topics)
    |> validate_assigned_topics(expected_topics)
    |> broadcast_unsubscribe_topics(topics)
    |> validate_assigned_topics([])
  end

  test "unsubscribe/3 removes topics (and excluding duplicates)" do
    topics = ["group:12345", "game", "game"]
    expected_topics = Enum.reverse(Enum.dedup(topics))

    connect()
    |> broadcast_subscribe_topics(topics)
    |> validate_assigned_topics(expected_topics)
    |> broadcast_unsubscribe_topics(topics)
    |> validate_assigned_topics([])
  end

  defp connect() do
    assert {:ok, _, socket} =
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("user:1", %{})
    socket
  end

  defp broadcast_subscribe_topics(socket, topics) do
    assert broadcast_from!(socket, "subscribe", %{topics: topics}) == :ok
    socket
  end

  defp broadcast_unsubscribe_topics(socket, topics) do
    assert broadcast_from!(socket, "unsubscribe", %{topics: topics}) == :ok
    socket
  end

  defp validate_assigned_topics(socket, expected_topics) do
    assert :sys.get_state(socket.channel_pid).assigns.topics == expected_topics
    socket
  end

  defp broadcast_message(socket, topic, payload) do
    assert broadcast_from!(socket, topic, payload) == :ok
    socket
  end
end