defmodule Mix.Tasks.Proto do
  @moduledoc "Generates protobuf definitions"
  use Mix.Task

  def run(_) do
    System.cmd("protoc", ["--elixir_out=./lib/", "proto/notifications.proto"])
  end
end