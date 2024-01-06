defmodule NotificationsServiceWeb.UserChannel do
  use Phoenix.Channel
  require Logger

  alias Phoenix.Socket.Broadcast

  def join("user:" <> request_user_id, _payload, socket = %{assigns: %{user_id: user_id}}) do
    if request_user_id == to_string(user_id) do
      {:ok, socket}
    else
      Logger.error("#{__MODULE__} failed #{request_user_id} != #{user_id}")
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end