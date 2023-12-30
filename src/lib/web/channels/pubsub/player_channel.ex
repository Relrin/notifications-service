defmodule NotificationsServiceWeb.PlayerChannel do
  use Phoenix.Channel

  def join("player:" <> player_id, _payload, socket) do
    if player_id_correct?(player_id) do
      {:ok, socket}
    else
      {:error, %{reason: "player_id is invalid"}}
    end
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  # TODO: Implement better handling for the player id: check against empty string & valid long integer
  defp player_id_correct?(player_id) do
    String.valid?(player_id)
  end
end