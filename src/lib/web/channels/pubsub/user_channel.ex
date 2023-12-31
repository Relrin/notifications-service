defmodule NotificationsServiceWeb.UserChannel do
  use Phoenix.Channel
  require Logger

  def join("user:" <> request_user_id, _payload,socket = %{assigns: %{user_id: user_id}}) do
    if request_user_id == to_string(user_id) do
      {:ok, socket}
    else
      Logger.error("#{__MODULE__} failed #{request_user_id} != #{user_id}")
      {:error, %{reason: "unauthorized"}}
    end
  end
end