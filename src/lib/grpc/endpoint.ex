defmodule NotificationsServiceGrpc.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger
  run NotificationsServiceGrpc.NotificationsService.Server
end
