defmodule NotificationsServiceWeb.PubSubToken do
  @one_day 86400
  @default_namespace "pubsub"

  def generate(user_id, opts \\ []) do
    salt = get_salt_key(opts)
    Phoenix.Token.sign(NotificationsServiceWeb.Endpoint, salt, user_id)
  end

  def verify(socket, token, opts \\ []) do
    salt = get_salt_key(opts)
    Phoenix.Token.verify(socket, salt, token, max_age: @one_day)
  end

  defp get_salt_key(opts) do
    Keyword.get(opts, :salt, @default_namespace)
  end
end