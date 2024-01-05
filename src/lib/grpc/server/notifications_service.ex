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

  def subscribe(%SubscribeRequest{user_ids: user_ids, topics: topics}, _stream) do
    Enum.each(user_ids, fn(user_id) ->
      NotificationsServiceWeb.Endpoint.broadcast!("user:#{user_id}", "subscribe", %{topics: topics})
    end)

    %SubscribeResponse{}
  end

  def unsubscribe(%UnsubscribeRequest{user_ids: user_ids, topics: topics}, _stream) do
    Enum.each(user_ids, fn(user_id) ->
      NotificationsServiceWeb.Endpoint.broadcast!("user:#{user_id}", "unsubscribe", %{topics: topics})
    end)

    %UnsubscribeResponse{}
  end

  def broadcast_text_message(%BroadcastTextMessageRequest{topic: topic, event: event, message: message}, _stream) do
    NotificationsServiceWeb.Endpoint.broadcast(topic, event, message)
    %BroadcastTextMessageResponse{}
  end
end