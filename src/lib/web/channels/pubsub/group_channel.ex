defmodule NotificationsServiceWeb.GroupChannel do
  use Phoenix.Channel
  require Logger

  alias Phoenix.Socket.Broadcast

  def join("group:" <> _request_group_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end