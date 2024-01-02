defmodule NotificationsServiceWeb.PubSubSocketTest do
  use NotificationsServiceWeb.ChannelCase
  use ExUnit.Case
  import ExUnit.CaptureLog

  alias NotificationsServiceWeb.{
    PubSubSocket,
    PubSubToken,
  }

  test "connect/3 is successful with a valid token" do
    assert {:ok, %Phoenix.Socket{}} =
            connect(PubSubSocket, %{"token" => PubSubToken.generate(1)})

    assert {:ok, %Phoenix.Socket{}} =
            connect(PubSubSocket, %{"token" => PubSubToken.generate(2)})
  end

  test "connect/3 fails with an invalid salt" do
    params = %{"token" => PubSubToken.generate(1, salt: "invalid")}

    assert capture_log(fn ->
             assert :error = connect(PubSubSocket, params)
           end) =~ "[error] #{PubSubSocket} connect error :invalid"
  end

  test "connect/3 fails with no token" do
    params = %{}

    assert capture_log(fn ->
             assert :error = connect(PubSubSocket, params)
           end) =~ "[error] #{PubSubSocket} connect error missing params"
  end

  test "connect/3 fails with an invalid token" do
    params = %{"token" => "invalid token"}

    assert capture_log(fn ->
             assert :error = connect(PubSubSocket, params)
           end) =~ "[error] #{PubSubSocket} connect error :invalid"
  end

  test "id/1 returns an identifier is based on the connected id" do
    assert {:ok, socket} =
             connect(PubSubSocket, %{"token" => PubSubToken.generate(1)})
    assert PubSubSocket.id(socket) == "pubsub_socket:1"

    assert {:ok, socket} =
             connect(PubSubSocket, %{"token" => PubSubToken.generate(2)})
    assert PubSubSocket.id(socket) == "pubsub_socket:2"
  end
end
