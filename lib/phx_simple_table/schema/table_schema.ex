defmodule PhxSimpleTable.Schema.TableSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "table_data" do
    field :name, :string
    timestamps()
  end

  def changeset(table_row, attrs) do
    table_row
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
