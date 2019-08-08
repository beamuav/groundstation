defmodule LiveViewDemoWeb.DialLive do
  use Phoenix.LiveView

  def render(assigns) do
    radius = 40
    cx = 50
    cy = 50
    angle = assigns.value / 100 * 270 + 90
    rad = angle * :math.pi() / 180
    x = round((cx + radius * :math.cos(rad)) * 1000) / 1000
    y = round((cy + radius * :math.sin(rad)) * 1000) / 1000

    ~L"""
    <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <path class="dial" fill="none" stroke="#eee" stroke-width="2" d="M 50 90 A <%= radius %> <%= radius %> 0 1 1 90 50" />
      <text x="50" y="50" fill="#999" class="value-text" text-anchor="middle" alignment-baseline="middle" dominant-baseline="central">
        <%= @value %>
      </text>
      <path class="value" fill="none" stroke="#666" stroke-width="2.5" d="M 50 90 A <%= radius %> <%= radius %> 0 <%= if angle > 270, do: 1, else: 0 %> 1 <%= x %> <%= y %>"></path>
    </svg>
    <form phx-change="update">
      <fieldset>
        <label>Value</label>
        <input type="range" min="0" max="100" name="value" value="<%= @value %>" />
        <%= @value %>
      </fieldset>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, put_value(socket, 0)}
  end

  def handle_event("update", %{"value" => value}, socket) do
    {:noreply, put_value(socket, String.to_integer(value))}
  end

  defp put_value(socket, value) do
    assign(socket, value: value)
  end
end
