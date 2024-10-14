defmodule PhxSimpleTableWeb.TableLive.Components.FilterComponent do
  require Logger
  alias PhxSimpleTable.Schema.TableSchema
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Filtering
  use PhxSimpleTableWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="filter-form" phx-target={@myself} phx-submit="search"
      phx-change="validate">
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-2 gap-4">
          <.input field={@form[:id]} type="number" label="ID" />
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:gender]} type="select" label="Gender" options={["Male", "Female", "Others"]} />
          <.input field={@form[:weight]} type="number" label="Weight" />
        </div>

        <:actions>
          <.button phx-disable-with="Saving..." disabled>Search</.button>
        </:actions>

      </.simple_form>



    </div>
    """
  end

  @impl true
  def update(%{filter: filter} = assigns, socket) do
    filter_changeset = TableSchema.changeset(filter)

    socket =
      socket
      |> assign(assigns)
      |> assign_form(filter_changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"table_schema" => filter_params}, socket) do
    filter_changeset =
      socket.assigns.filter
      |> TableSchema.changeset(filter_params)
      |> Map.put(:action, :validate)
      if
    {:noreply, assign_form(socket, filter_changeset)}
  end

  @impl true
  def handle_event("search", %{"table_schema" => filter_params}, socket) do
     IO.inspect(filter_params, label: "product params")
    IO.inspect(socket.assigns.filter, label: "socket.assigns.product")

      case Filtering.parse(filter_params) do
    #  case TableSchema.changeset(socket.assigns.filter, filter_params ) do

      {:ok, filter_opts} ->
        IO.inspect(filter_opts, label: "filter_opts")
        send(self(), {:update, filter_opts})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = filter_changeset} ->
        IO.inspect(filter_changeset, label: "line 70 error")
        {:noreply, assign_form(socket, filter_changeset)}
    end

    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  #   @impl true
  #   def handle_event("validate", %{"filter_params" => table_params}, socket) do
  #     # changeset =
  #     #   socket.assigns.product
  #     #   |> Store.change_product(product_params)
  #     #   |> Map.put(:action, :validate)
  #     #  {:noreply, assign_form(socket, changeset)}

  #  IO.inspect(table_params, label: "table_params")

  #     {:noreply, socket}
  #   end
end
