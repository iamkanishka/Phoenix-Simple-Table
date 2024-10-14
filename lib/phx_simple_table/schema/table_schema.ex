defmodule PhxSimpleTable.Schema.TableSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "table_data" do
    field :name, :string
    field :gender, :string
    field :weight, :integer

    timestamps()
  end

  @impl true
  def changeset(table_map, attrs \\ %{}) do
    table_map
    |> cast(attrs, [:id, :name, :gender, :weight])
    |> validate_required([])
    |> validate_number(:id, greater_than_or_equal_to: 0)
    |> validate_number(:weight, greater_than_or_equal_to: 0)

  end
end
