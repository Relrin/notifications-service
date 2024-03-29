defmodule NotificationsService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NotificationsServiceWeb.Telemetry,
      {GRPC.Server.Supervisor, endpoint: NotificationsServiceGrpc.Endpoint, port: 8080, start_server: true},
      {DNSCluster, query: Application.get_env(:notifications_service, :dns_cluster_query) || :ignore},
      get_pubsub_definition(),
      # Start a worker by calling: NotificationsService.Worker.start_link(arg)
      # {NotificationsService.Worker, arg},
      # Start to serve requests, typically the last entry
      NotificationsServiceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NotificationsService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotificationsServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp get_pubsub_definition() do
    if Mix.env == :prod do
      {Phoenix.PubSub,
        adapter: Phoenix.PubSub.Redis,
        name: NotificationsService.PubSub,
        node_name: System.get_env("NODE", "NotificationsService"),
        host: System.get_env("REDIS_HOST", "redis"),
        password: System.get_env("REDIS_PORT", ""),
        redis_pool_size: 10,
      }
    else
      {Phoenix.PubSub,
        adapter: Phoenix.PubSub.PG2,
        name: NotificationsService.PubSub
      }
    end
  end
end
