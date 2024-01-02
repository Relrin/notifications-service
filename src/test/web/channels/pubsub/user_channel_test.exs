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
end