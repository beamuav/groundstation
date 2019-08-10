defmodule GroundStationWeb.PageControllerTest do
  use GroundStationWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Ground Station"
  end
end
