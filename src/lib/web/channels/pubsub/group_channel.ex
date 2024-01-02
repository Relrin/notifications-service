defmodule NotificationsServiceWeb.GroupChannel do
  use Phoenix.Channel
  require Logger

  def join("group:" <> request_group_id, _payload, _socket = %{assigns: %{user_id: user_id}}) do
    Logger.error("#{__MODULE__} User #{user_id} tried to join the #{request_group_id} channel")
    {:error, %{reason: "unauthorized"}}
  end
end