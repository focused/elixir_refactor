defmodule Refactor.StackDraft do
  use Refactor.ComponentDraft, state: [0]
  require Logger

  defcast push(item, state) do
    [item | state]
  end

  defcall pop(state) do
    {hd(state), tl(state)}
  end

  # defcall pop([item | tail]) do
  #   {item, tail}
  # end

  # state_name: :stack
  #
  # defcall pop do
  #   set_state(tl(stack)) do
  #     hd(stack)
  #   end
  # end

  definfo clear(_state) do
    []
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
