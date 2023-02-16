defmodule Refactor.StackServer do
  use Refactor.GenComponent, state: [0], init: :load
  require Logger
  alias Refactor.Stack

  on_call pop do
    Stack.pop(state)
  end

  on_cast push(new_item) do
    Stack.push(state, new_item)
  end

  on_info clear do
    Stack.new()
  end

  on_continue load do
    Stack.load(state)
  end

  @impl GenServer
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
