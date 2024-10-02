defmodule PhxSimpleTable.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxSimpleTableWeb.Telemetry,
      PhxSimpleTable.Repo,
      {DNSCluster, query: Application.get_env(:phx_simple_table, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxSimpleTable.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhxSimpleTable.Finch},
      # Start a worker by calling: PhxSimpleTable.Worker.start_link(arg)
      # {PhxSimpleTable.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxSimpleTableWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxSimpleTable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxSimpleTableWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
