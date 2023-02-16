defmodule Refactor.StackServer do
  use Refactor.GenComponent, state: [0]
  require Logger
  alias Refactor.Stack

  def push(new_item), do: cast(:push, new_item)

  def pop, do: call(:pop)

  def clear, do: info(:clear)

  @impl true
  def handle_call(:pop, _from, state) do
    state |> Stack.pop() |> reply()
  end

  @impl true
  def handle_cast({:push, new_item}, state) do
    state |> Stack.push(new_item) |> noreply()
  end

  @impl true
  def handle_info(:clear, _state) do
    noreply(Stack.new())
  end

  # INIT

  @impl true
  def init(state) do
    ok_continue(state, :load)
  end

  # OTHER

  @impl true
  def handle_continue(:load, state) do
    state |> Stack.load() |> noreply()
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
