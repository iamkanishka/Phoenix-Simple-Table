defmodule PhxSimpleTableWeb.TableLive.Show do
  alias PhxSimpleTable.TableQuery
  use PhxSimpleTableWeb, :live_view

  def mount(_params, _session, socket) do
    table_list = TableQuery.list_table_data()

    socket =
      socket
      |> assign(:table_list, table_list)

    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
   {:noreply, socket}
  end

end
