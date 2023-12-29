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
    BroadcastBinaryMessageRequest,
    BroadcastBinaryMessageResponse,
  }

  def subscribe(%SubscribeRequest{player_ids: _player_ids, channels: _channels}, _stream) do
    # TODO: Call PubSub subscribe
    %SubscribeResponse{}
  end

  def unsubscribe(%UnsubscribeRequest{player_ids: _player_ids, channels: _channels}, _stream) do
    # TODO: Call PubSub unsubscribe
    %UnsubscribeResponse{}
  end

  def broadcast_text_message(%BroadcastTextMessageRequest{channels: _channels, message: _message}, _stream) do
    # TODO: Send data to the client(s) websocket
    %BroadcastTextMessageResponse{}
  end

  def broadcast_binary_message(%BroadcastBinaryMessageRequest{channels: _channels, message: _message}, _stream) do
    # TODO: Send data to the client(s) websocket
    %BroadcastBinaryMessageResponse{}
  end
end