defmodule FlightSimulatorTest do
  use ExUnit.Case

  alias FlightSimulator, as: FS

  doctest FlightSimulator, import: true

  @delta 0.0000000000001
  @big_delta 0.001

  test "Heading straight upor down gives no effective movement over ground" do
    assert_in_delta 0, FS.ground_distance(10, 10, 90), @delta
    assert_in_delta 0, FS.ground_distance(10, 10, -90), @delta
  end

  test "Heading 45 degrees up or down is proportional to sqrt(2)/2 " do
    assert_in_delta 70.71, FS.ground_distance(10, 10, 45), @big_delta
    assert_in_delta 70.71, FS.ground_distance(10, 10, -45), @big_delta
  end

  test "speed control, max and min" do
    assert FS.speed_up(%FS{speed: 50}).speed == 55
    assert FS.speed_up(%FS{speed: 200}).speed == 200
    assert FS.speed_down(%FS{speed: 50}).speed == 45
    assert FS.speed_down(%FS{speed: 10}).speed == 10
  end

  test "pitch control, max and min" do
    assert FS.pitch_up(%FS{pitch_angle: 0}).pitch_angle == 1
    assert FS.pitch_up(%FS{pitch_angle: 20}).pitch_angle == 20
    assert FS.pitch_down(%FS{pitch_angle: 0}).pitch_angle == -1
    assert FS.pitch_down(%FS{pitch_angle: -20}).pitch_angle == -20
  end

  test "roll control, max and min" do
    assert FS.roll_right(%FS{roll_angle: 0}).roll_angle == 1
    assert FS.roll_right(%FS{roll_angle: 50}).roll_angle == 50
    assert FS.roll_left(%FS{roll_angle: 0}).roll_angle == -1
    assert FS.roll_left(%FS{roll_angle: -50}).roll_angle == -50
  end

  test "yaw control, max and min" do
    assert FS.yaw_right(%FS{bearing: 0}).bearing == 1
    assert FS.yaw_right(%FS{bearing: 359}).bearing == 0
    assert FS.yaw_left(%FS{bearing: 0}).bearing == 359
    assert FS.yaw_left(%FS{bearing: 359}).bearing == 358
  end
end
