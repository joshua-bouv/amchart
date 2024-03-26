defmodule Amchart.Repo do
  use Ecto.Repo,
    otp_app: :amchart,
    adapter: Ecto.Adapters.Postgres
end
