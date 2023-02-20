defmodule Refactor.Stack.Server do
  @moduledoc """
  Stack server.
  """

  use GenServer
  require Logger
  import Refactor.GenServer.Reply
  alias Refactor.Stack.Implementation

  @spec start_link(Implementation.t()) :: GenServer.on_start()
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # @spec start_link(Implementation.t()) :: GenServer.on_start()
  # def start_link(state), do: Refactor.GenServer.Server.start_link(__MODULE__, state)

  @impl true
  def handle_call(:pop, _from, state) do
    state |> Implementation.pop() |> reply()
  end

  @impl true
  def handle_cast({:push, new_item}, state) do
    state |> Implementation.push(new_item) |> noreply()
  end

  @impl true
  def handle_info(:clear, _state), do: noreply(Implementation.new())

  # INIT

  @impl true
  def init(state), do: ok_continue(state, :load)

  # OTHER

  @impl true
  def handle_continue(:load, state) do
    state |> Implementation.load() |> noreply()
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
