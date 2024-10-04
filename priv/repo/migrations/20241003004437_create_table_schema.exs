defmodule PhxSimpleTable.Repo.Migrations.CreateTableSchema do
  use Ecto.Migration

  def change do
    create table(:table_data) do
      add(:name, :string)
      add(:gender, :string)
      add(:weight, :integer)

      timestamps()
    end

    create index(:table_data, :name)
    create index(:table_data, :weight)
    create index(:table_data, :gender)
  end
end
