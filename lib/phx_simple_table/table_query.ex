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



  def filter(query, opts) do
      # where(query, (query.name ilike ^opts.name) or (query.name == ^opts.name))
       where(query, ilike(query.name,  ^opts.name))

      where(query, query.gender == ^opts.gender)
      where(query, query.weight >= ^opts.weight)
      where(query, query.id >= ^opts.id)


  end

  # def filter_users(opts \\ %{}) do
  #   # Define a starting query
  #   query = from user in TableSchema,
  #     where: true  # Starting condition

  #   # Build a dynamic condition based on opts
  #   conditions = Enum.reduce(opts, query, fn
  #     {key, value} when value != nil ->
  #       where(query, user[:key] == ^value)
  #     _ ->
  #       query
  #   end)

  #   from user in conditions,
  #     select: user
  # end




  defp sort(query, _opts), do: query
  defp filter(query, _opts), do: query

end
