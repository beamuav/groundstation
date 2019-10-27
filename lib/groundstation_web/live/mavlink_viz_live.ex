defmodule GroundStationWeb.MavlinkVizLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(GroundStationWeb.PageView, "mavlink_viz.html", assigns)
  end

  def mount(session, socket) do
    MAVLink.Router.subscribe(message: APM.Message.VfrHud)
    MAVLink.Router.subscribe(message: APM.Message.GlobalPositionInt)
    MAVLink.Router.subscribe(message: APM.Message.Attitude)

    {:ok, assign(socket, vehicle: session.vehicle)}
  end

  def handle_info(
        %APM.Message.Attitude{roll: roll, pitch: pitch, yaw: yaw},
        socket
      ) do
    socket.assigns.vehicle
    |> Map.put(:pitch_angle, degrees(pitch))
    |> Map.put(:roll_angle, degrees(roll))
    |> Map.put(:yaw_angle, degrees(yaw))
    |> update_vehicle(socket)
  end

  def handle_info(
        %APM.Message.VfrHud{groundspeed: groundspeed, heading: heading},
        socket
      ) do
    socket.assigns.vehicle
    |> Map.put(:speed, groundspeed)
    |> Map.put(:bearing, heading)
    |> update_vehicle(socket)
  end

  def handle_info(
        %APM.Message.GlobalPositionInt{lat: lat, lon: lon, alt: alt, relative_alt: relative_alt},
        socket
      ) do
    location = %{lat: convert_gps(lat), lng: convert_gps(lon)}

    socket.assigns.vehicle
    |> Map.put(:location, location)
    |> Map.put(:altitude, metres(relative_alt))
    |> update_vehicle(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  def update_vehicle(state, socket) do
    {:noreply, assign(socket, :vehicle, state)}
  end

  defp convert_gps(val) do
    (val |> round()) / 10_000_000.0
  end

  defp degrees(val) do
    val / :math.pi() * 180.0
  end

  defp metres(val) do
    round(val) / 1000.0
  end
end
