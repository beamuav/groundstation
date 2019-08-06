defmodule LiveViewDemoWeb.CompassLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <rect fill="none" height="100" width="100" x="0" y="0" stroke="#eee" stroke-width="0.5" />
      <text font-size="5" font-weight="bold" x="50.5" y="7" text-anchor="middle"><%= assigns.heading %>º</text>
      <g transform="rotate(<%= assigns.heading %>)" transform-origin="50 50">
        <circle cx="50" cy="50" r="40" fill="whitesmoke" />
        <circle cx="50" cy="50" r="38" fill="none" stroke="#aaa" stroke-width="4" stroke-dasharray="0.25,4.72" stroke-dashoffset="0" />
        <circle cx="50" cy="50" r="38" fill="none" stroke="#aaa" stroke-width="4" stroke-dasharray="0.5,14.395" stroke-dashoffset="0" />
        <circle cx="50" cy="50" r="37" fill="none" stroke="#666" stroke-width="6" stroke-dasharray="0.75,57.4" stroke-dashoffset="29.3" />
        <circle cx="50" cy="50" r="37" fill="none" stroke="#111" stroke-width="6" stroke-dasharray="1,57.15" stroke-dashoffset="0.4" />
        <g id="cardinal">
          <text font-size="5" font-weight="bold" x="50" y="21" text-anchor="middle" transform="rotate(0)" transform-origin="50 50">N</text>
          <text font-size="5" font-weight="bold" x="50" y="21" text-anchor="middle" transform="rotate(90)" transform-origin="50 50">E</text>
          <text font-size="5" font-weight="bold" x="50" y="21" text-anchor="middle" transform="rotate(180)" transform-origin="50 50">S</text>
          <text font-size="5" font-weight="bold" x="50" y="21" text-anchor="middle" transform="rotate(270)" transform-origin="50 50">W</text>
        </g>
        <g id="primary-intercardinal">
          <text font-size="5" font-weight="normal" x="50" y="21" text-anchor="middle" transform="rotate(45)" transform-origin="50 50">NE</text>
          <text font-size="5" font-weight="normal" x="50" y="21" text-anchor="middle" transform="rotate(135)" transform-origin="50 50">SE</text>
          <text font-size="5" font-weight="normal" x="50" y="21" text-anchor="middle" transform="rotate(225)" transform-origin="50 50">SW</text>
          <text font-size="5" font-weight="normal" x="50" y="21" text-anchor="middle" transform="rotate(315)" transform-origin="50 50">NW</text>
        </g>
      </g>
      <g>
        <circle cx="50" cy="50" r="1.5" fill="none" stroke="red" stroke-width="0.5" />
        <circle cx="50" cy="50" r="1" fill="#333" />
        <line x1="50" y1="48.5" x2="50" y2="12" fill="none" stroke="red" stroke-width="0.5" stroke-linecap="round" />
      </g>
    </svg>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(250, self(), :tick)

    {:ok, put_heading(socket, 0)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_heading(socket, socket.assigns.heading + 1)}
  end

  defp put_heading(socket, heading) do
    assign(socket, heading: rem(heading, 360) )
  end
end
