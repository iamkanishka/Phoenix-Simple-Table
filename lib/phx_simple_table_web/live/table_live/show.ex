defmodule PhxSimpleTableWeb.TableLive.Show do
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Paginating
  alias PhxSimpleTable.Schema.PaginationSchema
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Filtering
  alias PhxSimpleTable.Schema.TableSchema
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

  @impl true
  def handle_info({:update, opts}, socket) do
    params = merge_and_sanitize_params(socket, opts)
    query_string = "/?" <> URI.encode_query(params)

    {:noreply,
     push_navigate(socket,
       to: query_string,
       replace: true
     )}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- Sorting.parse(params),
         {:ok, filtering_opts} <- Filtering.parse(params),
         {:ok, paginating_opts} <- Paginating.parse(params) do
      socket
      |> assign_sorting(sorting_opts)
      |> assign_filtering(filtering_opts)
      |> assign_pagination(paginating_opts)
    else
      _error ->
        socket
        |> assign_sorting()
        |> assign_filtering()
    end
  end

  defp assign_pagination(socket, overrides \\ %{}) do
    paginate_form_opts = Map.merge(%PaginationSchema{}, overrides)
    paginating_opts = Map.merge(Filtering.default_values(), overrides)

    socket
    |> assign(:paginate, paginate_form_opts)
    |> assign(:paginating, paginating_opts)
  end

  defp assign_filtering(socket, overrides \\ %{}) do
    form_opts = Map.merge(%TableSchema{}, overrides)
    opts = Map.merge(Filtering.default_values(), overrides)

    socket
    |> assign(:filter, form_opts)
    |> assign(:filtering, opts)
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(Sorting.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_table_list(socket) do
    params = merge_and_sanitize_params(socket)

    %{table_data: table_data, total_count: total_count} =
      TableQuery.list_table_data_with_total_count(params)

    socket
    |> assign(:table_list, table_data)
    |> assign_total_count(total_count)
  end

  # One way to update  a specfic key in socket
  # defp assign_total_count(socket, total_count) do
  #   update(socket, :pagination, fn pagination -> %{pagination | total_count: total_count} end)
  # end

  defp assign_total_count(socket, total_count) do
    assign(socket, :pagination, total_count)
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, filtering: filtering, paginating: paginating} = socket.assigns

    %{}
    |> Map.merge(sorting)
    |> Map.merge(filtering)
    |> Map.merge(paginating)
    |> Map.merge(overrides)
    |> Map.merge(overrides)
    |> Map.drop([:total_count])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end
end
