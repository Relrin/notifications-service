defmodule NotificationsServiceWeb.PubSubSocket do
  use Phoenix.Socket

  ## Channels
  channel "ping", NotificationsServiceWeb.PingChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
