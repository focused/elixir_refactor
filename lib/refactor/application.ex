defmodule Refactor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Refactor.Worker.start_link(arg)
      # {Refactor.Worker, arg}
      Refactor.StackOriginal,
      Refactor.StackDraft,
      {Refactor.ComponentServer, {Refactor.StackComponent.new([0]), Refactor.CompStackServer}},
      Refactor.StackServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Refactor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
