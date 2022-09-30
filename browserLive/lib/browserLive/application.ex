defmodule BrowserLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BrowserLiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BrowserLive.PubSub},
      # Start the Endpoint (http/https)
      BrowserLiveWeb.Endpoint
      # Start a worker by calling: BrowserLive.Worker.start_link(arg)
      # {BrowserLive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BrowserLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BrowserLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
