defmodule PhxSimpleTableWeb.TableLive.Components.SortingComponent do
  use PhxSimpleTableWeb, :live_component

  @doc false
  @impl true
  def render(assigns) do
    ~H"""
    <span class="text-black" phx-click="sort" phx-target={@myself}>
      <%= @key %>
      <% if @sorting.sort_by == :asc? do %>

        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 16 16"
          fill="black"

          aria-hidden="true"
          data-slot="icon"
        >
          <path
            fill-rule="evenodd"
            d="M8 2a.75.75 0 0 1 .75.75v8.69l1.22-1.22a.75.75 0 1 1 1.06 1.06l-2.5 2.5a.75.75 0 0 1-1.06 0l-2.5-2.5a.75.75 0 1 1 1.06-1.06l1.22 1.22V2.75A.75.75 0 0 1 8 2Z"
            clip-rule="evenodd"
          />
        </svg>
      <% else %>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 16 16"
          fill="black"
          aria-hidden="true"
          data-slot="icon"
        >
          <path
            fill-rule="evenodd"
            d="M8 2a.75.75 0 0 1 .75.75v8.69l1.22-1.22a.75.75 0 1 1 1.06 1.06l-2.5 2.5a.75.75 0 0 1-1.06 0l-2.5-2.5a.75.75 0 1 1 1.06-1.06l1.22 1.22V2.75A.75.75 0 0 1 8 2Z"
            clip-rule="evenodd"
            c
          />
        </svg>
      <% end %>
    </span>
    """
  end

  def handle_event("sort", _params, socket) do
    %{sorting: %{sort_dir: sort_dir}, key: key} = socket.assigns
    sort_dir = if sort_dir == :asc, do: :desc, else: :asc
    opts = %{sort_by: key, sort_dir: sort_dir}

    send(self(), {:update, opts})

    {:noreply, socket}
  end

  # def chevron(%{sorting: %{sort_by: sort_by, sort_dir: sort_dir}, key: key})  when sort_by == key do
  #   if sort_dir == :asc, do: "⇧", else: "⇩"
  # end

  # def chevron(_opts, _key), do: ""
end
