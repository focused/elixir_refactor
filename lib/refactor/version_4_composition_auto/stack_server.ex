defmodule Refactor.StackServer do
  use Refactor.GenComponent, state: [0], init: :load
  require Logger
  alias Refactor.Stack

  on_call pop(stack) do
    Stack.pop(stack)
  end

  on_cast push(new_item, stack) do
    Stack.push(stack, new_item)
  end

  on_info clear(_stack) do
    Stack.new()
  end

  on_continue load(stack) do
    Stack.load(stack)
  end

  @impl GenServer
  def terminate(reason, _stack) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
