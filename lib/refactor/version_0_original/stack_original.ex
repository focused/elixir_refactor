defmodule Refactor.StackOriginal do
  use GenServer
  require Logger

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  @impl true
  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  @impl true
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  @impl true
  def handle_info(:clear, _state) do
    {:noreply, []}
  end

  # INIT

  @impl true
  def init(state) do
    {:ok, state, {:continue, :load}}
  end

  # OTHER

  @impl true
  def handle_continue(:load, state) do
    {:noreply, state ++ [-1]}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
