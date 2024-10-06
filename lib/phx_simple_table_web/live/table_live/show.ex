defmodule PhxSimpleTableWeb.TableLive.Show do
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Sorting
  alias PhxSimpleTable.TableQuery
  use PhxSimpleTableWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket}
  # Update handle_params/3 like this:
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    path = Routes.live_path(socket, __MODULE__, opts)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  # Add this function:
  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- Sorting.parse(params) do
      assign_sorting(socket, sorting_opts)
    else
      _error ->
        assign_sorting(socket)
    end
  end

  # Add this function:
  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(Sorting.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  # Update assign_meerkats/1 like this:
  defp assign_meerkats(socket) do
    %{sorting: sorting} = socket.assigns

    IO.inspect(sorting, label: "just checking")

    # assign(socket, :table_data, TableQuery.list_table_data(sorting))
     assign(socket, :table_list, [])

  end
end
