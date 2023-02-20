defmodule Refactor.Stack.Client do
  @doc """
  Stack client.
  """

  alias Refactor.Stack.Implementation
  alias Refactor.Stack.Server

  @spec push(Implementation.member()) :: :ok
  def push(new_item), do: GenServer.cast(Server, {:push, new_item})

  @spec pop :: {Implementation.member(), Implementation.t()}
  def pop, do: GenServer.call(Server, :pop)

  @spec clear :: :clear
  def clear, do: send(Server, :clear)
end
