defmodule Refactor.StackServer do
  use GenServer

  require Logger

  import Refactor.Server

  alias Refactor.Server
  alias Refactor.StackClient
  alias Refactor.StackImpl

  def start_link(state), do: Server.start_link(__MODULE__, state)

  defdelegate push(new_item), to: StackClient
  defdelegate pop(), to: StackClient
  defdelegate clear(), to: StackClient

  @impl true
  def handle_call(:pop, _from, state) do
    state |> StackImpl.pop() |> reply()
  end

  @impl true
  def handle_cast({:push, new_item}, state) do
    state |> StackImpl.push(new_item) |> noreply()
  end

  @impl true
  def handle_info(:clear, _state), do: noreply(StackImpl.new())

  # INIT

  @impl true
  def init(state), do: ok_continue(state, :load)

  # OTHER

  @impl true
  def handle_continue(:load, state) do
    state |> StackImpl.load() |> noreply()
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
