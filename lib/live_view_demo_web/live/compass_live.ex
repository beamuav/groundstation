defmodule LiveViewDemoWeb.CompassLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <svg viewBox="-50 -50 100 100" xmlns="http://www.w3.org/2000/svg">
      <rect fill="none" height="100" width="100" x="-50" y="-50" stroke="#eee" stroke-width="0.5" />
      <text font-size="5" font-weight="bold" x="0.5" y="7" text-anchor="middle"><%= assigns.heading %>º</text>
      <g transform="rotate(<%= assigns.heading %>)">
        <circle  r="40" fill="whitesmoke" />
        <circle  r="38" fill="none" stroke="#aaa" stroke-width="4" stroke-dasharray="0.25 4.72" stroke-dashoffset="0" />
        <circle  r="38" fill="none" stroke="#aaa" stroke-width="4" stroke-dasharray="0.50 14.395" stroke-dashoffset="0" />
        <circle  r="37" fill="none" stroke="#666" stroke-width="6" stroke-dasharray="0.75 57.4" stroke-dashoffset="29.3" />
        <circle  r="37" fill="none" stroke="#111" stroke-width="6" stroke-dasharray="1.00 57.15" stroke-dashoffset="0.4" />
        <g id="cardinal">
          <text font-size="5" font-weight="bold" x="0" y="-29" text-anchor="middle" transform="rotate(0)">N</text>
          <text font-size="5" font-weight="bold" x="0" y="-29" text-anchor="middle" transform="rotate(90)">E</text>
          <text font-size="5" font-weight="bold" x="0" y="-29" text-anchor="middle" transform="rotate(180)">S</text>
          <text font-size="5" font-weight="bold" x="0" y="-29" text-anchor="middle" transform="rotate(270)">W</text>
        </g>
        <g id="primary-intercardinal">
          <text font-size="5" font-weight="normal" x="0" y="-29" text-anchor="middle" transform="rotate(45)">NE</text>
          <text font-size="5" font-weight="normal" x="0" y="-29" text-anchor="middle" transform="rotate(135)">SE</text>
          <text font-size="5" font-weight="normal" x="0" y="-29" text-anchor="middle" transform="rotate(225)">SW</text>
          <text font-size="5" font-weight="normal" x="0" y="-29" text-anchor="middle" transform="rotate(315)">NW</text>
        </g>
      </g>
      <g>
        <circle r="1.5" fill="none" stroke="red" stroke-width="0.5" />
        <circle r="1" fill="#333" />
        <line x1="0" y1="-1.5" x2="0" y2="-40" fill="none" stroke="red" stroke-width="0.5" stroke-linecap="round" />
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
