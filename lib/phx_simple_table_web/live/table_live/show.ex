defmodule PhxSimpleTableWeb.TableLive.Show do
  alias PhxSimpleTable.TableQuery
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Sorting
  use PhxSimpleTableWeb, :live_view

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_table_list()

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    {:noreply,
     push_navigate(socket,
       to: "/?sort_by=#{opts[:sort_by]}&sort_dir=#{opts[:sort_dir]}",
       replace: true
     )}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- Sorting.parse(params) do
      assign_sorting(socket, sorting_opts)
    else
      _error ->
        assign_sorting(socket)
    end
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(Sorting.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_table_list(socket) do
    %{sorting: sorting} = socket.assigns
    assign(socket, :table_list, TableQuery.list_table_data(sorting))
  end
end
