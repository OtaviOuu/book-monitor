defmodule Evmonitor.Repo do
  use Ecto.Repo,
    otp_app: :evmonitor,
    adapter: Ecto.Adapters.Postgres
end
