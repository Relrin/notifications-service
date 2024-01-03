defmodule NotificationsServiceWeb.UserChannel do
  use Phoenix.Channel
  require Logger

  intercept ["subscribe", "unsubscribe"]

  def join("user:" <> request_user_id, _payload, socket = %{assigns: %{user_id: user_id}}) do
    if request_user_id == to_string(user_id) do
      {:ok, socket}
    else
      Logger.error("#{__MODULE__} failed #{request_user_id} != #{user_id}")
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_out("subscribe", %{topics: topics}, socket) do
    next_socket = assign_new_topics(socket, topics)

    {:noreply, next_socket}
  end

  def handle_out("unsubscribe", %{topics: topics}, socket) do
    next_socket = remove_topics(socket, topics)

    {:noreply, next_socket}
  end

  defp assign_new_topics(socket, topics) do
    Enum.reduce(topics, socket, fn topic, acc ->
      existing_topics = Map.get(acc.assigns, :topics, [])
      if topic in existing_topics do
        acc
      else
        :ok = NotificationsServiceWeb.Endpoint.subscribe(topic)
        assign(acc, :topics, [topic | existing_topics])
      end
    end)
  end

  defp remove_topics(socket, topics) do
    Enum.reduce(topics, socket, fn topic, acc ->
      existing_topics = Map.get(acc.assigns, :topics, [])
      if topic in existing_topics do
        :ok = NotificationsServiceWeb.Endpoint.unsubscribe(topic)
        assign(acc, :topics, Enum.reject(existing_topics, fn topic_name -> topic_name == topic end))
      else
        acc
      end
    end)
  end
end