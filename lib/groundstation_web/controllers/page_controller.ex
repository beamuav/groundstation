defmodule GroundStationWeb.PageController do
  use GroundStationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def simulator(conn, _params) do
    sydney_airport = %FlightSimulator{
      location: %{lat: -33.964592291602244, lng: 151.18069727924058},
      bearing: 347.0
    }

    live_render(conn, GroundStationWeb.SimulatorLive, session: %{simulator: sydney_airport})
  end

  def mavlink_viz(conn, _params) do
    mavlink_vehicle =
      camp_wombaroo =
      %Vehicle{
        location: %{lat: -34.3889458, lng: 150.3293791}
      }
      |> IO.inspect()

    live_render(
      conn,
      GroundStationWeb.MavlinkVizLive,
      session: %{vehicle: camp_wombaroo}
    )
  end
end
