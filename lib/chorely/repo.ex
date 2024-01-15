defmodule Chorely.Repo do
  use Ecto.Repo,
    otp_app: :chorely,
    adapter: Ecto.Adapters.Postgres
end
