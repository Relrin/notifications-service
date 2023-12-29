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
  live_view: [signing_salt: "zWJLFl5Q"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# gRPC server setup
config :gprc,
  start_server: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
