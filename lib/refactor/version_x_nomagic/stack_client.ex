defmodule Refactor.StackClient do
  alias Refactor.StackImpl
  alias Refactor.StackServer

  @spec push(StackImpl.member()) :: :ok
  def push(new_item), do: GenServer.cast(StackServer, {:push, new_item})

  @spec pop :: {StackImpl.member(), StackImpl.t()}
  def pop, do: GenServer.call(StackServer, :pop)

  @spec clear :: :clear
  def clear, do: send(StackServer, :clear)
end
