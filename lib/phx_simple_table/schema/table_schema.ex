defmodule PhxSimpleTable.Schema.TableSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "table_data" do
    field :name, :string
    field :gender, :string
    field :weight, :integer

    timestamps()
  end

  def changeset(table_row, attrs \\ %{}) do
    table_row
    |> cast(attrs, [:name, :gender, :weight])
    |> validate_required([:name, :gender, :weight])
  end
end
