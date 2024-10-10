defmodule PhxSimpleTableWeb.TableLive.Components.FilterComponent do
  require Logger
  alias PhxSimpleTable.Schema.TableSchema
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Filtering
  use PhxSimpleTableWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="filter-form" phx-target={@myself} phx-submit="search">
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-2 gap-4">
          <.input field={@form[:id]} type="number" label="ID" />
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:gender]} type="select" label="Gender"  options={["Male", "Female"]} />
          <.input field={@form[:weight]} type="number" label="Weight" />
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Search</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    Logger.info("State initiated")
    table_changeset = TableSchema.changeset(%TableSchema{})

    {:ok,
     socket
     |> assign_form(table_changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event("search", %{"filter" => filter}, socket) do
    case Filtering.parse(filter) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
