defmodule PhxSimpleTableWeb.TableLive.Components.PaginatiomComponent do
  use PhxSimpleTableWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
     <div>



     </div>

    <div>
      <.simple_form
        for={@form}
        id="filter-form"
        phx-target={@myself}
        phx-submit="search"
        phx-change="validate"
      >
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-2 gap-4">
          <.input type="select" label="" options={[10, 20, 30, 40, 50]} />
        </div>
      </.simple_form>
    </div>
    """
  end

  def pages(%{page_size: page_size, page: current_page, total_count: total_count}) do
    page_count = ceil(total_count / page_size)

    for page_number <- 1..page_count//1 do
      current_page? = page_number == current_page
      {page_number, current_page?}
    end
  end

  @impl true
  def handle_event("show_page", params, socket) do
    parse_params(params, socket)
  end

  @impl true
  def handle_event("set_page_size", %{"page_size" => params}, socket) do
    parse_params(params, socket)
  end


  defp parse_params(params, socket) do
    %{pagination: pagination} = socket.assigns

    case PaginationForm.parse(params, pagination) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end
end
