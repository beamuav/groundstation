defmodule GroundStationWeb.SimulatorLive do
  use Phoenix.LiveView

  @tick 15
  @tick_seconds @tick / 1000

  def render(assigns) do
    ~L"""
    <div class="wrapper" phx-keydown="control_input" phx-target="window">
      <header class="top">
        <h3>Ground Control to Major Tom</h3>
      </header>
      <div class="left">
        <%= live_render(@socket, GroundStationWeb.GaugeLive) %>
        <%= live_render(@socket, GroundStationWeb.DialLive) %>
        <%= live_render(@socket, GroundStationWeb.DialLive) %>
      </div>
      <div class="right">
        <div>Altitude <b><%= Float.round(@simulator.altitude, 1) %></b> m</div>
        <div>Speed <b><%= Float.round(@simulator.speed, 1) %></b> m/s</div>
        <div>Lat <b><%= Float.round(@simulator.location.lat, 5) %></b></div>
        <div>Lng <b><%= Float.round(@simulator.location.lng, 5) %></b></div>

      </div>

      <div class="main-top-left">
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

          <g transform="rotate(<%= @simulator.roll_angle %>)">
            <g transform="translate(0 <%= @simulator.pitch_angle %>)">
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
      </div>
      <div class="main-bottom-left">
        <svg viewBox="-50 -50 100 100" xmlns="http://www.w3.org/2000/svg">
          <text font-size="5" font-weight="bold" x="0.5" y="-43" text-anchor="middle"><%= Float.round(@simulator.bearing,1) %>º</text>
          <g transform="rotate(-<%= @simulator.bearing %>)">
            <circle r="40" fill="whitesmoke" />
            <circle r="38" fill="none" stroke="#aaa" stroke-width="4" stroke-dasharray="0.25 4.72" stroke-dashoffset="0" />
            <circle r="38" fill="none" stroke="#aaa" stroke-width="4" stroke-dasharray="0.50 14.395" stroke-dashoffset="0" />
            <circle r="37" fill="none" stroke="#666" stroke-width="6" stroke-dasharray="0.75 57.4" stroke-dashoffset="29.3" />
            <circle r="37" fill="none" stroke="#111" stroke-width="6" stroke-dasharray="1.00 57.15" stroke-dashoffset="0.4" />
            <g id="cardinal" font-size="5" font-weight="bold" text-anchor="middle" fill="#333">
              <text x="0" y="-29" transform="rotate(0)">N</text>
              <text x="0" y="-29" transform="rotate(90)">E</text>
              <text x="0" y="-29" transform="rotate(180)">S</text>
              <text x="0" y="-29" transform="rotate(270)">W</text>
            </g>
            <g id="primary-intercardinal" font-size="5" font-weight="normal" text-anchor="middle" fill="#333">
              <text x="0" y="-29" transform="rotate(45)">NE</text>
              <text x="0" y="-29" transform="rotate(135)">SE</text>
              <text x="0" y="-29" transform="rotate(225)">SW</text>
              <text x="0" y="-29" transform="rotate(315)">NW</text>
            </g>
          </g>
          <g>
            <circle r="1.5" fill="none" stroke="red" stroke-width="0.5" />
            <circle r="1" fill="#333" />
            <line x1="0" y1="-1.5" x2="0" y2="-40" fill="none" stroke="red" stroke-width="0.5" stroke-linecap="round" />
          </g>
        </svg>

      </div>
      <div id="view" class="main-top-right"></div>
      <div id="map" class="main-bottom-right"></div>

      <footer class="bottom">
      </footer>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(@tick, self(), :tick)

    {:ok, assign(socket, simulator: %FlightSimulator{})}
  end

  def handle_info(:tick, socket) do
    socket.assigns.simulator
    |> FlightSimulator.update(@tick_seconds)
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => code}, socket)
      when code in ["ArrowLeft", "KeyA"] do
    socket.assigns.simulator
    |> FlightSimulator.roll_left()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => code}, socket)
      when code in ["ArrowRight", "KeyD"] do
    socket.assigns.simulator
    |> FlightSimulator.roll_right()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => code}, socket)
      when code in ["ArrowUp", "KeyW"] do
    socket.assigns.simulator
    |> FlightSimulator.pitch_down()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => code}, socket)
      when code in ["ArrowDown", "KeyS"] do
    socket.assigns.simulator
    |> FlightSimulator.pitch_up()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => "Minus"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.speed_down()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => "Equal"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.speed_up()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => "Comma"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.yaw_left()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => "Period"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.yaw_right()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"code" => "Space"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.reset_attitude()
    |> update_simulator(socket)
  end

  def handle_event("control_input", key, socket) do
    # IO.inspect("Unhandled: #{inspect(key)}")
    {:noreply, socket}
  end

  def update_simulator(state, socket) do
    # IO.inspect(state)
    {:noreply, assign(socket, :simulator, state)}
  end
end
