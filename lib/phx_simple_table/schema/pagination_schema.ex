defmodule PhxSimpleTable.Schema.PaginationSchema do
  use Ecto.Schema
 import Ecto.Changeset

  schema "pages" do
    field :page_size, :integer
  end


  @impl true
  def changeset(page_size,  attrs \\ %{})  do
  page_size
  |>  cast(attrs, [:page_size])
  |>  validate_required([:page_size])
  |>  validate_number(:page_size,  greater_than_or_equal_to: 1)
  end


end
