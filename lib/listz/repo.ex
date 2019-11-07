defmodule Listz.Repo do
  use Ecto.Repo,
    otp_app: :listz,
    adapter: Ecto.Adapters.Postgres
end
