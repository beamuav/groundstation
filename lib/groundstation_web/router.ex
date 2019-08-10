defmodule GroundStationWeb.Router do
  use GroundStationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GroundStationWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/compass", CompassLive
    live "/horizon", HorizonLive
    live "/dial", DialLive
    live "/gauge", GaugeLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", GroundStationWeb do
  #   pipe_through :api
  # end
end
