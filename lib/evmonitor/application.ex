defmodule Evmonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EvmonitorWeb.Telemetry,
      Evmonitor.Repo,
      {DNSCluster, query: Application.get_env(:evmonitor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Evmonitor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Evmonitor.Finch},
      # Start a worker by calling: Evmonitor.Worker.start_link(arg)
      # {Evmonitor.Worker, arg},
      # Start to serve requests, typically the last entry
      EvmonitorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Evmonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EvmonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
