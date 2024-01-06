defmodule NotificationsServiceGrpc.NotificationsService.Server do
  @moduledoc """
  Server implementation for the Notifications service.
  """
  use GRPC.Server, service: Notifications.NotificationsService.Service

  alias Notifications.{
    BroadcastTextMessageRequest,
    BroadcastTextMessageResponse,
  }

  def broadcast_text_message(%BroadcastTextMessageRequest{topics: topics, event: event, message: message}, _stream) do
    Enum.each(topics, fn(topic) ->
      NotificationsServiceWeb.Endpoint.broadcast(topic, event, message)
    end)

    %BroadcastTextMessageResponse{}
  end
end