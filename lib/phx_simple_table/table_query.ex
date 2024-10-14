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
    |> filter(opts)
    |> sort(opts)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:id, :name, :gender, :weight] and
              sort_dir in [:asc, :desc] do
    order_by(query, {^sort_dir, ^sort_by})
  end

  defp filter(query, opts) do
    query
    |> filter_by_id(opts)
    |> filter_by_name(opts)
    |> filter_by_gender(opts)
    |> filter_by_weight(opts)
  end

  defp filter_by_id(query, %{id: id}) when is_integer(id) do
    where(query, id: ^id)
  end

  defp filter_by_gender(query, %{gender: gender}) when is_binary(gender) and gender != "" do
    where(query, gender: ^gender)
  end

  defp filter_by_weight(query, %{weight: weight}) when is_integer(weight) do
    where(query, weight: ^weight)
  end

  defp filter_by_name(query, %{name: name})
       when is_binary(name) and name != "" do
    query_string = "%#{name}%"
    where(query, [m], ilike(m.name, ^query_string))
  end

  defp filter_by_id(query, _opts), do: query
  defp filter_by_name(query, _opts), do: query
  defp filter_by_gender(query, _opts), do: query
  defp filter_by_weight(query, _opts), do: query

  defp sort(query, _opts), do: query
end
