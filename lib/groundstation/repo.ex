defmodule GroundStation.Repo do
  use Ecto.Repo,
    otp_app: :groundstation,
    adapter: Ecto.Adapters.Postgres
end
