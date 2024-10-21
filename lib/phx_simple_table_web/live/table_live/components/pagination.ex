defmodule PhxSimpleTableWeb.TableLive.Components.Pagination do
  require Logger
  alias PhxSimpleTableWeb.TableLive.CustomSchemas.Paginating
  alias PhxSimpleTable.Schema.PaginationSchema
  use PhxSimpleTableWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex  justify-end  gap-3">
      <%!-- <div class="mt-2 mx-5">
        <nav>
          <ul class="inline-flex  text-sm">
            <%= for {page_number, current_page?} <- pages(@paginating) do %>
              <li phx-click="show_page" phx-target={@myself} phx-value-page={page_number}>
                <a
                  href="javascript:void(0)"
                  class={
                    if current_page?,
                      do:
                        "flex items-center justify-center px-3 h-10 text-blue-600 border border-gray-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white",
                      else:
                        "flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                  }
                >
                  <%= page_number %>
                </a>
              </li>
            <% end %>
          </ul>
        </nav>
      </div> --%>

      <div class="flex items-center gap-3">

      <div class="text-sm font-medium text-black ">
         Total Records:   <%= @paginating[:total_count] %>
        </div>

        <a
          href="javascript:void(0)"
          class="flex items-center justify-center px-4 h-9 text-sm font-medium text-black bg-white border border-gray-300 rounded-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
          phx-target={@myself}
          phx-click="traverse-previous"
        >
          Previous
        </a>

        <div class="text-sm font-medium text-black ">
          <%= @paginating[:page] %> / <%= length(pages(@paginating)) %>
        </div>

        <a
          href="javascript:void(0)"
          class="flex items-center justify-center px-4 h-9 ms-3 text-sm font-medium text-black bg-white border border-gray-300 rounded-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
          phx-target={@myself}
          phx-click="traverse-next"
        >
          Next
        </a>
      </div>

      <div class="mb-1">
        <.simple_form
          for={@paginate_form}
          id="pagination-form"
          class="w-20"
          phx-target={@myself}
          phx-change="show_page"
        >
          <.input type="select" field={@paginate_form[:page]} label="" options={pages(@paginating)} />
        </.simple_form>
      </div>

      <div class="mb-1">
        <.simple_form
          for={@paginate_form}
          id="pagination-form"
          class="w-20"
          phx-target={@myself}
          phx-change="set_page_size"
        >
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
      # {page_number, current_page?}

      page_number
    end
  end

  def handle_event(
        "traverse-previous",
        _params,
        socket
      ) do
    pagination_params = socket.assigns.paginating
    IO.inspect(pagination_params, label: "pagination_params")

    if pagination_params[:page] != 0 and pagination_params[:page] >= 1 do
      parse_params(%{page: pagination_params[:page] - 1}, socket)
    else
      {:noreply, socket}
    end
  end

  def handle_event(
        "traverse-next",
        _params,
        socket
      ) do
    pagination_params = socket.assigns.paginating
    pages_length = length(pages(pagination_params))

    if pagination_params[:page] <= pages_length and pagination_params[:page] >= 1 do
      parse_params(%{page: pagination_params[:page] + 1}, socket)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("show_page", %{"pagination_schema" => params}, socket) do
    parse_params(params, socket)
  end

  @impl true
  def handle_event("set_page_size", %{"pagination_schema" => params}, socket) do
    new_params = Map.put(params, "page", 1)
    parse_params(new_params, socket)
  end

  defp parse_params(params, socket) do
    IO.inspect(params)
    %{paginating: paginating} = socket.assigns

    case Paginating.parse(params, paginating) do
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
