defmodule PhxSimpleTable.TableQuery do
  alias PhxSimpleTable.Schema.TableSchema

  import Ecto.Query, warn: false

  alias PhxSimpleTable.Repo
  alias PhxSimpleTable.Schema.TableSchema

  @doc """
  Fetch table Data
  """
  def list_table_data(opts) do
    # Get all Data
    # Repo.all(TableSchema)

    # get Sorted Data
    from(m in TableSchema)
    |> sort(opts)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:id, :name, :gender, :weight] and
              sort_dir in [:asc, :dec] do
    order_by(query, {^sort_by, ^sort_dir})
  end

  defp sort(query, _opts), do: query
end
