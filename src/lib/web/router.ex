defmodule NotificationsServiceWeb.Router do
  use NotificationsServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NotificationsServiceWeb do
    pipe_through :api

    get "/healthz", K8sController, :healthz
  end
end
