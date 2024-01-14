defmodule Chorely.Repo do
  use AshPostgres.Repo, otp_app: :chorely

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
