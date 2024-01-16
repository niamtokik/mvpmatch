defmodule Mvpmatch.Repo do
  use Ecto.Repo,
    otp_app: :mvpmatch,
    adapter: Ecto.Adapters.Postgres
end
