defmodule PhxSimpleTable.TableQuery do
  alias PhxSimpleTable.Schema.TableSchema

  alias PhxSimpleTable.Repo
  import Ecto.Query, warn: false

  require Logger

  def list_table_data(opts) do
    # Fetch all Table Data
    #  Repo.all(TableSchema)

    # Fetch Table Data with Sort

    from(m in TableSchema)
    |> sort(opts)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:id, :name, :gender, :weight] and
              sort_dir in [:asc, :desc] do
      order_by(query, { ^sort_dir, ^sort_by})
  end

  defp sort(query, _opts), do: query
end
