defmodule GroundStationWeb.ConsoleLive do
  use Phoenix.LiveView

  @help [
    "commands:",
    "  status       Output vehicle status",
    "  clear        Clears the console output"
  ]

  def render(assigns) do
    Phoenix.View.render(GroundStationWeb.PageView, "console.html", assigns)
  end

  def mount(session, socket) do
    tick(nil)

    MAVLink.Router.subscribe(message: APM.Message.VfrHud)
    MAVLink.Router.subscribe(message: APM.Message.GlobalPositionInt)
    MAVLink.Router.subscribe(message: APM.Message.Attitude)

    {:ok, assign(socket, console: session.console)}
  end

  def handle_event("control_input", %{"code" => "Escape"}, socket) do
    socket.assigns.console
    |> Map.update!(:open, fn open -> !open end)
    |> update_console(socket)
  end

  def handle_event("control_input", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("console", %{"command" => %{"input" => "status"}}, socket) do
    socket.assigns.console
    |> Map.update!(:history, fn history -> ["status" | history] end)
    |> Map.update!(:mode, fn _ -> :status end)
    |> update_console(socket)
  end

  def handle_event("console", %{"command" => %{"input" => "opacity " <> opacity}}, socket) do
    case Float.parse(opacity) do
      {n, _} ->
        socket.assigns.console
        |> Map.update!(:history, fn history -> ["status" | history] end)
        |> Map.update!(:opacity, fn _ -> n end)
        |> update_console(socket)

      :error ->
        socket.assigns.console
        |> Map.update!(:mode, fn _ -> {:error, "could not parse opacity"} end)
        |> update_console(socket)
    end
  end

  def handle_event("console", %{"command" => %{"input" => "help"}}, socket) do
    socket.assigns.console
    |> Map.update!(:history, fn history -> ["help" | history] end)
    |> Map.update!(:mode, fn _ -> :help end)
    |> update_console(socket)
  end

  def handle_event("console", %{"command" => %{"input" => "clear"}}, socket) do
    socket.assigns.console
    |> Map.update!(:history, fn history -> ["clear" | history] end)
    |> Map.update!(:mode, fn _ -> :clear end)
    |> update_console(socket)
  end

  def handle_event("console", %{"command" => %{"input" => ""}}, socket) do
    socket.assigns.console
    |> Map.update!(:mode, fn _ -> nil end)
    |> update_console(socket)
  end

  def handle_event("console", %{"command" => %{"input" => input}}, socket) do
    socket.assigns.console
    |> Map.update!(:mode, fn _ -> {:error, "command not found #{input}"} end)
    |> update_console(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  def update_console(state, socket) do
    {:noreply, assign(socket, :console, state)}
  end

  def tick(reply) do
    Process.send_after(self(), :tick, 10)
    reply
  end

  def slice_messages(messages), do: Enum.slice(messages, 0..50)

  def handle_info(:tick, %{assigns: %{console: %{mode: :help}}} = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn messages -> slice_messages(Enum.reverse(@help) ++ messages) end)
    |> Map.update!(:mode, fn _ -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(:tick, %{assigns: %{console: %{mode: :clear}}} = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn _ -> [] end)
    |> Map.update!(:mode, fn _ -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(:tick, %{assigns: %{console: %{mode: {:error, message}}}} = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn messages -> slice_messages([message | messages]) end)
    |> Map.update!(:mode, fn _ -> nil end)
    |> update_console(socket)
    |> tick
  end

  def status_messages(vehicle, updated_at) do
    Enum.reverse([
      "altitude #{vehicle.altitude}",
      "latitude: #{vehicle.location.lat}",
      "longitude: #{vehicle.location.lng}",
      "speed: #{vehicle.speed}",
      "bearing: #{vehicle.bearing}",
      "updated at: #{updated_at}"
    ])
  end

  def handle_info(
        :tick,
        %{assigns: %{console: %{mode: :status, vehicle: vehicle, vehicle_updated_at: updated_at}}} =
          socket
      ) do
    socket.assigns.console
    |> Map.update!(:messages, fn _ -> status_messages(vehicle, updated_at) end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(:tick, %{assigns: %{console: %{mode: _}}} = socket) do
    socket.assigns.console
    |> Map.update!(:mode, fn _ -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(
        %APM.Message.GlobalPositionInt{lat: lat, lon: lon, alt: alt, relative_alt: relative_alt},
        %{assigns: %{console: %{mode: :status, vehicle: vehicle}}} = socket
      ) do
    socket.assigns.console
    |> Map.update!(:vehicle, fn _ -> Map.update!(vehicle, :altitude, fn _ -> alt end) end)
    |> Map.update!(:vehicle, fn _ ->
      Map.update!(vehicle, :location, fn _ -> %{lat: lat, lng: lon} end)
    end)
    |> Map.update!(:vehicle_updated_at, fn _ -> DateTime.utc_now() end)
    |> update_console(socket)
  end

  def handle_info(
        %APM.Message.VfrHud{groundspeed: groundspeed, heading: heading},
        %{assigns: %{console: %{mode: :status, vehicle: vehicle}}} = socket
      ) do
    socket.assigns.console
    |> Map.update!(:vehicle, fn _ -> Map.update!(vehicle, :speed, fn _ -> groundspeed end) end)
    |> Map.update!(:vehicle, fn _ -> Map.update!(vehicle, :bearing, fn _ -> heading end) end)
    |> Map.update!(:vehicle_updated_at, fn _ -> DateTime.utc_now() end)
    |> update_console(socket)
  end

  def handle_info(
        %APM.Message.Attitude{roll: roll, pitch: pitch, yaw: yaw},
        %{assigns: %{console: %{mode: :status, vehicle: vehicle}}} = socket
      ) do
    socket.assigns.console
    |> Map.update!(:vehicle_updated_at, fn _ -> DateTime.utc_now() end)
    |> update_console(socket)
  end

  def handle_info(message, socket) do
    {:noreply, socket}
  end
end
