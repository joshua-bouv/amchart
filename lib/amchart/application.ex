defmodule Amchart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AmchartWeb.Telemetry,
      Amchart.Repo,
      {DNSCluster, query: Application.get_env(:amchart, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Amchart.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Amchart.Finch},
      # Start a worker by calling: Amchart.Worker.start_link(arg)
      # {Amchart.Worker, arg},
      # Start to serve requests, typically the last entry
      AmchartWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Amchart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AmchartWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
