defmodule GroundStationWeb.PageController do
  use GroundStationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
