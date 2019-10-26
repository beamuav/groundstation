defmodule GroundStationWeb.ConsoleLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(GroundStationWeb.PageView, "console.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, console: session.console)}
  end

  def handle_event("control_input", %{"code" => "MetaLeft"}, socket) do
    socket.assigns.console
    |> Map.update!(:open, fn(open) -> !open end)
    |> update_console(socket)
  end

  def handle_event("control_input", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("console", %{"command" => %{"input" => input}}, socket) do
    socket.assigns.console
    |> Map.update!(:history, fn(history) -> [ input | history ] end)
    |> update_console(socket)
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  def update_console(state, socket) do
    {:noreply, assign(socket, :console, state)}
  end
end
