defmodule PhxSimpleTable.InfinityTableQuery do
  alias PhxSimpleTable.Schema.TableSchema

  alias PhxSimpleTable.Repo
  import Ecto.Query, warn: false

  require Logger

  def table_list_count(), do: Repo.aggregate(TableSchema, :count)

  def list_table_data_with_pagination(offset, limit) do
    from(m in TableSchema)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end
end
