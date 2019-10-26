defmodule Vehicle do
  @moduledoc """
  The state of a simulated aircraft

  ## Units

  - All angles are expressed in degrees (and are converted to radians internally when needed)
  - All distances are expressed in metres
  - All speeds are expressed in metres per second

  Drone -> MavLink Proxy -> | Mavlink Router | ->   Message/State Aggregator -> Live View

  or

  Flight Simulator -> Live View
  """

  defstruct bearing: 0.0,
            altitude: 0.0,
            pitch_angle: 0.0,
            roll_angle: 0.0,
            speed: 0.0,
            location: %{lat: 0.0, lng: 0.0}
end
