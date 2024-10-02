defmodule PhxSimpleTable.Repo do
  use Ecto.Repo,
    otp_app: :phx_simple_table,
    adapter: Ecto.Adapters.Postgres
end
