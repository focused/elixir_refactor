defmodule Refactor.StackServerSimple do
  use Refactor.GenComponentSimple, state: [0]
  require Logger
  alias Refactor.StackSimple

  def push(new_item), do: cast(:push, new_item)

  def pop, do: call(:pop)

  def clear, do: info(:clear)

  @impl true
  def handle_call(:pop, _from, state) do
    state |> StackSimple.pop() |> reply()
  end

  @impl true
  def handle_cast({:push, new_item}, state) do
    state |> StackSimple.push(new_item) |> noreply()
  end

  @impl true
  def handle_info(:clear, _state) do
    noreply(StackSimple.new())
  end

  # INIT

  @impl true
  def init(state) do
    ok_continue(state, :load)
  end

  # OTHER

  @impl true
  def handle_continue(:load, state) do
    state |> StackSimple.load() |> noreply()
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
