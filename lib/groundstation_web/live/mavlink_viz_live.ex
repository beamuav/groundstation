defmodule GroundStationWeb.MavlinkVizLive do
  use Phoenix.LiveView

  def render(assigns) do
    IO.inspect(assigns)
    Phoenix.View.render(GroundStationWeb.PageView, "mavlink_viz.html", assigns)
  end

  def mount(session, socket) do
    IO.inspect(session)
    MAVLink.Router.subscribe(message: APM.Message.VfrHud)
    MAVLink.Router.subscribe(message: APM.Message.GlobalPositionInt)

    {:ok, assign(socket, vehicle: session.vehicle)}
  end

  # def handle_info(
  #       message,
  #       socket
  #     ) do
  #   IO.inspect(message)
  #   {:noreply, socket}
  # end

  def handle_info(
        message = %APM.Message.VfrHud{groundspeed: groundspeed, heading: heading, alt: alt},
        socket
      ) do
    IO.inspect(message)

    socket.assigns.vehicle
    |> Map.update(speed: groundspeed)
    |> Map.update(bearing: heading)
    |> Map.update(alt: alt)
    |> update_vehicle(socket)
  end

  def handle_info(
        message = %APM.Message.GlobalPositionInt{lat: lat, lon: lon},
        socket
      ) do
    IO.inspect(message)

    socket.assigns.vehicle
    |> Map.update(location: %{lat: lat, lng: lon})
    |> update_vehicle(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  def update_vehicle(state, socket) do
    {:noreply, assign(socket, :vehicle, state)}
  end
end
