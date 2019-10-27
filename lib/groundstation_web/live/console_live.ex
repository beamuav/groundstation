defmodule GroundStationWeb.ConsoleLive do
  use Phoenix.LiveView

  @help [
    "commands:",
    "  logs         Output latest Mavlink messages",
    "  clear        Clears the console output",
  ]

  def render(assigns) do
    Phoenix.View.render(GroundStationWeb.PageView, "console.html", assigns)
  end

  def mount(session, socket) do
    tick(nil)
    MAVLink.Router.subscribe()
    {:ok, assign(socket, console: session.console)}
  end

  def handle_event("control_input", %{"code" => "Escape"}, socket) do
    socket.assigns.console
    |> Map.update!(:open, fn(open) -> !open end)
    |> update_console(socket)
  end

  def handle_event("control_input", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("console", %{"command" => %{"input" => input}}, socket) do
    mode = case input do
      "logs" -> :logs
      "help" -> :help
      "clear" -> :clear
      "" -> nil
      _ -> { :error, "command not found #{input}" }
    end
    socket.assigns.console
    |> Map.update!(:history, fn(history) -> [ input | history ] end)
    |> Map.update!(:mode, fn(_) -> mode end)
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

  # def handle_info(:tick, %{ assigns: %{ console: %{ mode: :logs } } } = socket) do
  #   socket.assigns.console
  #   |> Map.update!(:messages, fn(messages) -> Enum.slice([ DateTime.utc_now() | messages ], 0..50) end)
  #   |> update_console(socket)
  #   |> tick
  # end

  def slice_messages(messages), do: Enum.slice(messages, 0..50)

  def handle_info(:tick, %{ assigns: %{ console: %{ mode: :help } } } = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn(messages) -> slice_messages(Enum.reverse(@help) ++ messages) end)
    |> Map.update!(:mode, fn(_) -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(:tick, %{ assigns: %{ console: %{ mode: :clear } } } = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn(_) -> [] end)
    |> Map.update!(:mode, fn(_) -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(:tick, %{ assigns: %{ console: %{ mode: {:error, message } } } } = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn(messages) -> slice_messages([message | messages ]) end)
    |> Map.update!(:mode, fn(_) -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(:tick, %{ assigns: %{ console: %{ mode: _ } } } = socket) do
    socket.assigns.console
    |> Map.update!(:mode, fn(_) -> nil end)
    |> update_console(socket)
    |> tick
  end

  def handle_info(message, %{ assigns: %{ console: %{ mode: :logs } } } = socket) do
    socket.assigns.console
    |> Map.update!(:messages, fn(messages) -> slice_messages([message | messages ]) end)
    |> update_console(socket)
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end
end
