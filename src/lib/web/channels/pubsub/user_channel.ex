defmodule NotificationsServiceWeb.UserChannel do
  use Phoenix.Channel
  require Logger

  intercept ["subscribe_internal", "unsubscribe_internal"]

  def join("user:" <> request_user_id, _payload, socket = %{assigns: %{user_id: user_id}}) do
    if request_user_id == to_string(user_id) do
      {:ok, socket}
    else
      Logger.error("#{__MODULE__} failed #{request_user_id} != #{user_id}")
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_out("subscribe_internal", %{"topics" => topics}, socket) do
    assign_new_topics(socket, topics)
    {:noreply, socket}
  end

  def handle_out("unsubscribe_internal", %{"topics" => topics}, socket) do
    remove_topics(socket, topics)
    {:noreply, socket}
  end

  defp assign_new_topics(socket, topics) do
    Enum.reduce(topics, socket, fn topic, acc ->
      existing_topics = acc.assigns.topics
      if topic in existing_topics do
        acc
      else
        :ok = NotificationsServiceWeb.Endpoint.subscribe(topic)
        assign(acc, :topics, [topic | topics])
      end
    end)
  end

  defp remove_topics(socket, topics) do
    Enum.reduce(topics, socket, fn topic, acc ->
      existing_topics = acc.assigns.topics
      if topic in existing_topics do
        :ok = NotificationsServiceWeb.Endpoint.unsubscribe(topic)
      end

      acc
    end)
  end
end