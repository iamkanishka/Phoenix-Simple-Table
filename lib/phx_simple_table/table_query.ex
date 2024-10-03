defmodule PhxSimpleTable.TableQuery do
alias PhxSimpleTable.Schema.TableSchema

  import Ecto.Query, warn: false

  alias PhxSimpleTable.Repo
  alias PhxSimpleTable.Schema.TableSchema

  def list_table_data() do
    Repo.all(TableSchema)
  end


end
