defmodule GroundStationWeb.MavlinkVizLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(GroundStationWeb.PageView, "mavlink_viz.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, vehicle: session.vehicle)}
  end

  def handle_info(:mavlink_message, socket) do
    socket.assigns.vehicle
    |> update_vehicle(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  def update_vehicle(state, socket) do
    {:noreply, assign(socket, :vehicle, state)}
  end
end
