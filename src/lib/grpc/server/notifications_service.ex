defmodule NotificationsServiceGrpc.NotificationsService.Server do
  @moduledoc """
  Server implementation for the Notifications service.
  """
  use GRPC.Server, service: Notifications.NotificationsService.Service

  alias Notifications.{
    SubscribeRequest,
    SubscribeResponse,
    UnsubscribeRequest,
    UnsubscribeResponse,
    BroadcastTextMessageRequest,
    BroadcastTextMessageResponse,
  }

  def subscribe(%SubscribeRequest{player_ids: player_ids, topics: topics}, _stream) do
    Enum.each(player_ids, fn(player_id) ->
      NotificationsServiceWeb.Endpoint.broadcast!("player:#{player_id}", "subscribe", %{topics: topics})
    end)

    %SubscribeResponse{}
  end

  def unsubscribe(%UnsubscribeRequest{player_ids: player_ids, topics: topics}, _stream) do
    Enum.each(player_ids, fn(player_id) ->
      NotificationsServiceWeb.Endpoint.broadcast!("player:#{player_id}", "unsubscribe", %{topics: topics})
    end)

    %UnsubscribeResponse{}
  end

  def broadcast_text_message(%BroadcastTextMessageRequest{topics: topics, message: message}, _stream) do
    Enum.each(topics, fn(topic) ->
      Phoenix.PubSub.broadcast(NotificationsService.PubSub, topic, {:message, %{payload: message}})
    end)

    %BroadcastTextMessageResponse{}
  end
end