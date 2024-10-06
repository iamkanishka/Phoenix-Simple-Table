defmodule PhxSimpleTable.TableQuery do
  alias PhxSimpleTable.Schema.TableSchema

  alias PhxSimpleTableWeb.Repo
  import Ecto.Query, warn: false

  def list_table_data(opts) do
    # Fetch all Table Data
    #  Repo.all(TableSchema)

    # Fetch Table Data with Sort

    from(m in TableSchema)
    |> sort(opts)
    |> Rep.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:id, :name, :gender, :weight] and
              sort_dir in [:asc, :desc] do
                IO.inspect(sort_by, sort_dir, lablel: "orderby")
    order_by(query, {^sort_by, ^sort_dir})
  end

  defp sort(query, _opts), do: query
end
