defmodule PhxSimpleTable.Repo.Migrations.CreateTableSchema do
  use Ecto.Migration

  def change do
    create table(:table_data) do
      add(:name, :string)

      timestamps()
    end

    create index(:table_data, :name)
  end
end
