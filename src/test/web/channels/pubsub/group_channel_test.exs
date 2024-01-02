defmodule NotificationsServiceWeb.GroupChannelTest do
  use NotificationsServiceWeb.ChannelCase
  import ExUnit.CaptureLog

  alias NotificationsServiceWeb.{
    PubSubSocket,
    GroupChannel,
  }

  test "join/3 failed for a user accessing private channel" do
    assert capture_log(fn ->
             socket(PubSubSocket, "pubsub_socket:1", %{user_id: 1})
             |> subscribe_and_join("group:private_group", %{}) == {:error, %{reason: "unauthorized"}}
           end) =~ "[error] #{GroupChannel}"
  end
end