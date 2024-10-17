defmodule PhxSimpleTableWeb.InfinityTableLive.Show do
  alias PhxSimpleTable.InfinityTableQuery
  use PhxSimpleTableWeb, :live_view

  def mount(_params, _session, socket) do
    count = InfinityTableQuery.table_list_count()

    socket =
      socket
      |> assign(offset: 0, limit: 15, count: count)
      |> load_table_data()

    {:ok, socket, temporary_assigns: [table_list: []]}
  end

  defp load_table_data(socket) do
    %{offset: offset, limit: limit} = socket.assigns
    table_data = InfinityTableQuery.list_table_data_with_pagination(offset, limit)
    stream(socket, :table_list, table_data)
  end




  def handle_event("ping", params, socket) do
    IO.inspect("ping", label: "Event")
    IO.inspect(params, label: "Params")
    {:noreply, push_event(socket, "pong", %{message: "Hello there!"})}
  end



  def handle_event("load-more", _params, socket) do
    %{offset: offset, limit: limit, count: count} = socket.assigns

    socket =
      if offset < count do
        socket
        |> assign(offset: offset + limit)
        |> load_table_data()
      else
        socket
      end

    {:noreply, socket}
  end
end
