defmodule MediaWishlist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MediaWishlistWeb.Telemetry,
      # Start the Ecto repository
      MediaWishlist.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: MediaWishlist.PubSub},
      # Start Finch
      {Finch, name: MediaWishlist.Finch},
      # Start the Endpoint (http/https)
      MediaWishlistWeb.Endpoint
      # Start a worker by calling: MediaWishlist.Worker.start_link(arg)
      # {MediaWishlist.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MediaWishlist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MediaWishlistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
