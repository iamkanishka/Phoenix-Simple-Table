defmodule PhxSimpleTableWeb.TableLive.Components.Pagination do
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Paginating
  alias PhxSimpleTable.Schema.PaginationSchema
  use PhxSimpleTableWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex  justify-end ">

      <div class="mt-2 mx-5">
        <nav>
          <ul class="inline-flex  text-sm">

          <%= for {page_number, current_page?} <- pages(@paginating) do %>

            <li>
              <a
                href="#"
                class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
              >
              <%= page_number %>
              </a>
            </li>
            <% end %>

            <%!-- <li>
              <a
                href="#"
                class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
              >
                2
              </a>
            </li>

            <li>
              <a
                href="#"
                aria-current="page"
                class="flex items-center justify-center px-3 h-10 text-blue-600 border border-gray-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white"
              >
                3
              </a>
            </li>

            <li>
              <a
                href="#"
                class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
              >
                4
              </a>
            </li>

            <li>
              <a
                href="#"
                class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
              >
                5
              </a>
            </li> --%>
          </ul>
        </nav>
      </div>

      <div>
        <.simple_form for={@paginate_form} id="pagination-form" class="w-20" phx-target={@myself}>
          <.input
            type="select"
            field={@paginate_form[:page_size]}
            label=""
            options={[10, 20, 30, 40, 50]}
          />
        </.simple_form>
      </div>


    </div>
    """
  end

  @impl true
  def update(%{paginate: paginate} = assigns, socket) do
    paginate_changeset = PaginationSchema.changeset(paginate)

    socket =
      socket
      |> assign(assigns)
      |> assign_form(paginate_changeset)

    {:ok, socket}
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

    case Paginating.parse(params, pagination) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :paginate_form, to_form(changeset))
  end
end
