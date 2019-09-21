defmodule FlightSimulator do
  import Geocalc

  @moduledoc """
  The state of a simulated aircraft with ability to control basic parameters and
  update them over time.

  ## Units

  - All angles are expressed in degrees (and are converted to radians internally when needed)
  - All distances are expressed in metres
  - All speeds are expressed in metres per second
  """

  @pitch_delta 1
  @max_pitch_angle 20
  @min_pitch_angle -20

  @roll_delta 1
  @max_roll_angle 30
  @min_roll_angle -30

  @yaw_delta 1

  @speed_delta 5
  @min_speed 15
  @max_speed 100

  defstruct bearing: 0.0,
            altitude: 500.0,
            pitch_angle: 0.0,
            roll_angle: 0.0,
            speed: 50.0,
            location: {0.0, 0.0}

  # Control input functions

  def speed_down(state),
    do: struct(state, speed: max(state.speed - @speed_delta, @min_speed))

  def speed_up(state),
    do: struct(state, speed: min(state.speed + @speed_delta, @max_speed))

  def pitch_down(state),
    do: struct(state, pitch_angle: max(state.pitch_angle - @pitch_delta, @min_pitch_angle))

  def pitch_up(state),
    do: struct(state, pitch_angle: min(state.pitch_angle + @pitch_delta, @max_pitch_angle))

  def roll_left(state),
    do: struct(state, roll_angle: max(state.roll_angle - @roll_delta, @min_roll_angle))

  def roll_right(state),
    do: struct(state, roll_angle: min(state.roll_angle + @roll_delta, @max_roll_angle))

  def yaw_left(state),
    do: struct(state, bearing: rem(state.bearing - @yaw_delta, 360))

  def yaw_right(state),
    do: struct(state, bearing: rem(state.bearing + @yaw_delta, 360))

  @doc """
  Calculate the changes in the simulator state over the time given in seconds.

  ## Example

      iex> update(%FlightSimulator{}, 10)
      %FlightSimulator{
        altitude: 500.0,
        pitch_angle: 0.0,
        roll_angle: 0.0,
        speed: 50.0,
        bearing: 0.0,
        location: {0.004496608029593652, 0.0}
      }

  """
  def update(state, time) do
    distance = ground_distance(state.speed, time, state.pitch_angle)

    struct(state,
      bearing: state.bearing + bearing_delta_for_roll(state.roll_angle, state.speed, time),
      altitude: state.altitude + altitude_delta(distance, state.pitch_angle),
      location: updated_location(state.location, state.bearing, distance)
    )
  end

  @doc """
  Calculate ground distance given speed (metres/second) and time (seconds).

  Account for the pitch angle to calculate the actual distance travelled across the ground.

  ## Example

      iex> ground_distance(10, 1, 0)
      10.0
      iex> ground_distance(10, 10, 0)
      100.0

  """
  def ground_distance(speed, time, pitch_angle) do
    speed * time * cos(pitch_angle)
  end

  @doc """
  Calculate the change in altitude given the actual distance travelled (not ground distance).

  ## Example

      iex> altitude_delta(10, 0)
      0.0
      iex> altitude_delta(10, 30)
      4.999999999999999
      iex> altitude_delta(10, 90)
      10.0

  """
  def altitude_delta(distance, pitch_angle) do
    distance * sin(pitch_angle)
  end

  @doc """
  Calculate the change in bearing (degrees) given the roll angle (degrees), speed (in m/s) and time (in seconds).

  ## Example

      iex> bearing_delta_for_roll(0, 100, 100)
      0.0
      iex> bearing_delta_for_roll(10, 100, 0)
      0.0
      iex> bearing_delta_for_roll(10, 50, 1)
      1.979301705471317
      iex> bearing_delta_for_roll(-10, 50, 1)
      -1.979301705471317

  """
  def bearing_delta_for_roll(roll_angle, speed, time) do
    time * rate_of_turn(roll_angle, speed)
  end

  @doc """
  Calculate rate of turn (in degrees / second) given roll angle (in degrees) and current speed (in m/s) .

  See http://www.flightlearnings.com/2009/08/26/rate-of-turn/

  ## Example

      iex> rate_of_turn(30, 60)
      5.400716176417849
      iex> rate_of_turn(-30, 60)
      -5.400716176417849
      iex> rate_of_turn(10, 60)
      1.6494180878927642
      iex> rate_of_turn(-10, 60)
      -1.6494180878927642

  """
  @knots_per_metre_per_second 1.9438444924406
  @rot_constant 1_091
  def rate_of_turn(roll_angle, speed) do
    @rot_constant * tan(roll_angle) / (speed * @knots_per_metre_per_second)
  end

  @doc """
  Calculate new location for distance (in metres) and bearing (in degrees) from current location

  Need this for lat/lng point given distance and bearing
  http://www.movable-type.co.uk/scripts/latlong.html#dest-point
  """
  def updated_location({lat, lng}, bearing, distance) do
    {:ok, [lat_new, lng_new]} =
      destination_point({lat, lng}, degrees_to_radians(bearing), distance)

    {lat_new, lng_new}
  end

  defp sin(a), do: :math.sin(degrees_to_radians(a))
  defp cos(a), do: :math.cos(degrees_to_radians(a))
  defp tan(a), do: :math.tan(degrees_to_radians(a))
end
