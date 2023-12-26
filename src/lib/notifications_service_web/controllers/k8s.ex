defmodule NotificationsServiceWeb.K8sController do
  use NotificationsServiceWeb, :controller

  def healthz(connection, _params) do
    json(connection, "OK")
  end
end