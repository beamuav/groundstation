defmodule LiveViewDemoWeb.GaugeLive do
  use Phoenix.LiveView

  def render(assigns) do
    normalised_value = 97 * (assigns.value / assigns.max_value) + 1
    ~L"""
    <svg viewBox="0 0 100 30" xmlns="http://www.w3.org/2000/svg">
      <rect fill="none" height="30" width="100" x="0" y="0" stroke="#eee" stroke-width="0.5" />
      <g id="text" alignment-baseline="top" font-size="10">
        <text class="label-text" x="1" y="10"><%= @label %> (<%= @units %>)</text>
        <text class="value-text" x="99" y="10" font-weight="bold" text-anchor="end">
          <%= @value %>
        </text>
      </g>
      <g id="lines">
        <defs>
          <marker id="marker" markerWidth="1" markerHeight="5" refY="5" orient="auto">
            <line x1="0" y1="0" x2="0" y2="20" stroke="black"/>
          </marker>
        </defs>
        <line id="gauge-range" x1="1" y1="25" x2="98" y2="25" stroke="black" marker-start="url(#marker)" marker-end="url(#marker)" />
        <path id="gauge-pointer" d="M <%= normalised_value %>,24 L <%= normalised_value - 3  %>,15 L <%= normalised_value + 3 %>,15 Z" fill="red" stroke="#222" stroke-width="0.5" />
      </g>
    </svg>
    <form phx-change="update">
      <fieldset>
        <label>Value</label>
        <input type="range" min="0" max="3000" name="value" value="<%= @value %>" />
        <strong><%= @value %></strong>
        <%= @units %>
      </fieldset>
    </form>

    """
  end

  def mount(_session, socket) do
    {:ok,
     socket
     |> assign(label: "FUEL", units: "mL", max_value: 3000, min_value: 0)
     |> put_value(3000)}
  end

  def handle_event("update", %{"value" => value}, socket) do
    {:noreply, put_value(socket, String.to_integer(value))}
  end

  defp put_value(socket, value) do
    assign(socket, value: value)
  end
end
