defmodule NotificationsServiceWeb.PubSubToken do
  @one_day 86400
  @namespace "pubsub"

  def generate(connection, user_id) do
    Phoenix.Token.sign(connection, @namespace, user_id)
  end

  def verify(socket, token) do
    Phoenix.Token.verify(socket, @namespace, token, max_age: @one_day)
  end
end