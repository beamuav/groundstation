defmodule GroundStationWeb.HorizonLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <svg viewBox="-50 -50 100 100" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="sky" x2="0%" y2="100%">
          <stop offset="0%" stop-color="darkblue" />
          <stop offset="66%" stop-color="blue" />
          <stop offset="100%" stop-color="skyblue" />
        </linearGradient>
        <linearGradient id="ground" x2="0%" y2="100%">
          <stop offset="0%" stop-color="sienna" />
          <stop offset="80%" stop-color="darkbrown" />
          <stop offset="100%" stop-color="black" />
        </linearGradient>
        <radialGradient id="circle-fade-mask" x2="0%" y2="100%">
          <stop offset="0%" stop-color="transparent" stop-opacity="0" />
          <stop offset="60%" stop-color="transparent" stop-opacity="0.8" />
          <stop offset="100%" stop-color="black" stop-opacity="0.9" />
        </radialGradient>
      </defs>

      <g transform="rotate(<%= @roll_angle %>)">
        <g transform="translate(0 <%= @pitch_angle %>)">
          <rect fill="url(#sky)" height="200" width="200" x="-100" y="-200" />
          <rect fill="url(#ground)" height="200" width="200" x="-100" y="0" stroke="white" stroke-width="0.25" />

          <g id="pitch-tape">
            <g id="pitch-labels" fill="white" font-size="3" text-anchor="middle" alignment-baseline="middle">
              <text x="-20" y="-20">20</text>
              <text x="20" y="-20">20</text>
              <text x="-20" y="-10">10</text>
              <text x="20" y="-10">10</text>
              <text x="-20" y="10">10</text>
              <text x="20" y="10">10</text>
              <text x="-20" y="20">20</text>
              <text x="20" y="20">20</text>
            </g>

            <g id="pitch-angle-lines" stroke="white">
              <line x1="-15" y1="-20" x2="15" y2="-20" stroke-width="0.5"/>
              <line x1="-15" y1="-10" x2="15" y2="-10" stroke-width="0.5"/>
              <line x1="-15" y1="10" x2="15" y2="10" stroke-width="0.5"/>
              <line x1="-15" y1="20" x2="15" y2="20" stroke-width="0.5"/>
              <line x1="-10" y1="-15" x2="10" y2="-15" stroke-width="0.25"/>
              <line x1="-10" y1="-5" x2="10" y2="-5" stroke-width="0.25"/>
              <line x1="-10" y1="5" x2="10" y2="5" stroke-width="0.25"/>
              <line x1="-10" y1="15" x2="10" y2="15" stroke-width="0.25"/>
            </g>
          </g>
        </g>
        <path id="pitch-pointer" d="M 0,-45 L -1.5,-42 L 1.5,-42 Z" fill="white" />
        <!-- <circle id="mask" r="40" fill="url(#circle-fade-mask)" /> -->
      </g>

      <g id="pitch-angle">
        <path id="pitch-arc" d="M-45,0 A5,5 0 1,1 45,0" fill="none" stroke="white" stroke-width="0.5" />
        <path id="pitch-ticks" d="M-44,0 A5,5 0 1,1 44,0" fill="none" stroke="white" stroke-width="2" stroke-dasharray="0.25,7.41" stroke-dashoffset="0" />
        <path id="pitch-pointer" d="M 0,-45 L -1.5,-48 L 1.5,-48 Z" fill="white" />
      </g>

      <g id="level-indicator" stroke="yellow" stroke-width="1.5" stroke-linecap="round">
        <line x1="-45" y1="0" x2="-25" y2="0" />
        <line x1="45" y1="0" x2="25" y2="0" />
        <line x1="-5" y1="4" x2="0" y2="0" stroke-linecap="square"  stroke-width="1" />
        <line x1="5" y1="4" x2="0" y2="0" stroke-linecap="square" stroke-width="1" />
      </g>
    </svg>
    <form phx-change="update">
      <label>Roll</label>
      <input type="range" min="-180" max="180" name="roll_angle" value="<%= @roll_angle %>" />
      <%= @roll_angle %>º
      <label>Pitch</label>
      <input type="range" min="-30" max="30" name="pitch_angle" value="<%= @pitch_angle %>" />
      <%= @pitch_angle %>º
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, put_attitude(socket, 0, 0)}
  end

  def handle_event("update", %{"roll_angle" => roll_angle, "pitch_angle" => pitch_angle}, socket) do
    {:noreply,
     put_attitude(socket, String.to_integer(roll_angle), String.to_integer(pitch_angle))}
  end

  defp put_attitude(socket, roll_angle, pitch_angle) do
    assign(socket, roll_angle: rem(roll_angle, 360), pitch_angle: rem(pitch_angle, 360))
  end
end
