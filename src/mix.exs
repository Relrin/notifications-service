defmodule NotificationsService.MixProject do
  use Mix.Project

  def project do
    [
      app: :notifications_service,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {NotificationsService.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bandit, ">= 0.0.0"},
      {:dns_cluster, "~> 0.1.1"},
      {:grpc, "~> 0.7.0"},
      {:google_protos, "~> 0.3.0"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.7.10"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:notifications_proto, path: "./lib/proto", app: false, compile: "cd ../.. && mix proto"},
    ]
  end

  defp aliases do
    [
      # https://github.com/elixir-protobuf/protobuf?tab=readme-ov-file#usage
      setup_protobuf: ["escript.install hex protobuf --force"]
    ]
  end
end
