defmodule Refactor.NomagicStack.Server do
  use GenServer

  require Logger

  alias Refactor.NomagicStack.Implementation

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def handle_call(:pop, _from, stack) do
    {reply, stack} = Implementation.pop(stack)
    {:ok, reply, stack}
  end

  @impl true
  def handle_cast({:push, new_item}, stack) do
    Implementation.push(stack, new_item)
    |> then(&{:noreply, &1})
  end

  @impl true
  def handle_info(:clear, _stack) do
    Implementation.new()
    |> then(&{:noreply, &1})
  end

  # INIT

  @impl true
  def init(stack) do
    {:ok, stack, {:continue, :load}}
  end

  # OTHER

  @impl true
  def handle_continue(:load, stack) do
    Implementation.load(stack)
    |> then(&{:noreply, &1})
  end

  @impl true
  def terminate(reason, _stack) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
