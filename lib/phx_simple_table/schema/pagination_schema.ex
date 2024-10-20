defmodule PhxSimpleTable.Schema.PaginationSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :page_size, :integer
    field :page, :integer
  end

  @impl true
  def changeset(pagination, attrs \\ %{}) do
    pagination
    |> cast(attrs, [:page_size, :page])
    |> validate_required([:page_size, :page])
    |> validate_number(:page_size, greater_than_or_equal_to: 1)
    |> validate_number(:page, greater_than_or_equal_to: 1)
  end
end
