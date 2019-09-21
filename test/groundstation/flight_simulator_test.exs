defmodule FlightSimulatorTest do
  use ExUnit.Case

  import FlightSimulator
  
  doctest FlightSimulator, import: true

  @delta 0.0000000000001
  @big_delta 0.001

  test "Heading straight upor down gives no effective movement over ground" do
    assert_in_delta 0, ground_distance(10, 10, 90), @delta
    assert_in_delta 0, ground_distance(10, 10, -90), @delta
  end

  test "Heading 45 degrees up or down is proportional to sqrt(2)/2 " do
    assert_in_delta 70.71, ground_distance(10, 10, 45), @big_delta
    assert_in_delta 70.71, ground_distance(10, 10, -45), @big_delta
  end
end
