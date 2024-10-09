defmodule PhxSimpleTableWeb.TableLive.Components.FilterComponent do
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Filtering
  use PhxSimpleTableWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
    <.simple_form
        for={@changeset}
        id="filter-form"
        phx-target={@myself}

        phx-submit="search"
      >
        <.input field={@changeset[:name]} type="text" label="Name" />
        <.input field={@changeset[:gender]} type="text" label="Gender" />

        <.input field={@changeset[:weight]} type="number" label="Weight" />
       <:actions>
          <.button phx-disable-with="Saving...">Search</.button>
        </:actions>
      </.simple_form>
    </div>

    """
  end


  # def update(%{filter: filter}, socket) do
#   {:ok, assign(socket, :changeset, Filtering.change_values(filter))}
  # end


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
