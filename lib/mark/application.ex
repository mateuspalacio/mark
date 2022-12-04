defmodule Mark.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Mark.Repo,
      # Start the Telemetry supervisor
      MarkWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mark.PubSub},
      # Start the Endpoint (http/https)
      MarkWeb.Endpoint
      # Start a worker by calling: Mark.Worker.start_link(arg)
      # {Mark.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mark.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MarkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
