# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :notifications_service,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :notifications_service, NotificationsServiceWeb.Endpoint,
  url: [host: "127.0.0.1"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: NotificationsServiceWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: NotificationsService.PubSub,
  secret_key_base: System.get_env("SECRET_KEY_BASE", "generate your own token with `mix phx.gen.secret`"),
  encryption_salt: System.get_env("ENCRYPTION_SALT", "some encryption salt key")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
