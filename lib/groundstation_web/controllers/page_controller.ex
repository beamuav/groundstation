defmodule GroundStationWeb.PageController do
  use GroundStationWeb, :controller

  def index(conn, _params) do
    live_render(conn, GroundStationWeb.SimulatorLive, session: %{})
  end
end
