defmodule Aprs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Start the Ecto repository
      Aprs.Repo,
      # Start the Telemetry supervisor
      AprsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Aprs.PubSub},
      # Start the Endpoint (http/https)
      AprsWeb.Endpoint,
      # Start a worker by calling: Aprs.Worker.start_link(arg)
      # {Aprs.Worker, arg}
      {Registry, keys: :duplicate, name: Registry.PubSub, partitions: System.schedulers_online()},
      Aprs.Is.IsSupervisor,
      # Aprs.Is,
      {Cluster.Supervisor, [topologies, [name: Aprs.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aprs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AprsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
