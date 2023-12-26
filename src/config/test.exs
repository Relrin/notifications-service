import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :notifications_service, NotificationsServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 8002],
  secret_key_base: "rdawzf2ondk7A5zn7e+itSTe3CmZ8M7X/Ta/9OCVWxj69mFNZnRNQljEPYlgzDta",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
