defmodule PhxSimpleTableWeb.TableLive.Show do
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Sorting
  alias PhxSimpleTable.TableQuery
  use PhxSimpleTableWeb, :live_view

  require Logger

  def mount(_params, _session, socket), do: {:ok, socket}
  # Update handle_params/3 like this:
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_table_list()

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    Logger.info "handling query"
    IO.inspect(opts, label: "params")
    IO.inspect(opts.sort_by, label: "params")

    IO.inspect(opts.sort_dir, label: "params")

    #  This Dosent work
    # path = Routes.live_path(socket, __MODULE__, opts)
    # {:noreply, push_patch(socket, to: path, replace: true)}

    #  This works
     {:noreply, push_navigate(socket, to: "/?sort_by=#{opts[:sort_by]}&sort_dir=#{opts[:sort_dir]}", replace: true)}



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

  # Update assign_table_list/1 like this:
  defp assign_table_list(socket) do
    %{sorting: sorting} = socket.assigns
    IO.inspect(sorting, label: "Just Checking show.ex 56")
       assign(socket, :table_list, TableQuery.list_table_data(sorting))

  end
end
