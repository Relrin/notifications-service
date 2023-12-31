defmodule NotificationsServiceWeb.PubSubSocket do
  use Phoenix.Socket
  require Logger

  alias NotificationsServiceWeb.{PubSubToken}

  # Channels
  channel "ping", NotificationsServiceWeb.PingChannel
  channel "user:*", NotificationsServiceWeb.UserChannel

  def connect(%{"token" => token}, socket) do
    case PubSubToken.verify(socket, token) do
      {:ok, user_id} ->
        socket = assign(socket, :user_id, user_id)
        {:ok, socket}

      {:error, err} ->
        Logger.error("#{__MODULE__} connect error #{inspect(err)}")
        :error
    end
  end

  def connect(_, _socket) do
    Logger.error("#{__MODULE__} connect error missing params")
    :error
  end

  def id(%{assigns: %{user_id: user_id}}),
    do: "pubsub_socket:#{user_id}"
end
