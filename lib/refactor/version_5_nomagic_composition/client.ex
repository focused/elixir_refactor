defmodule Refactor.NomagicStack.Client do
  @server Refactor.NomagicStack.Server

  def push(new_item), do: GenServer.cast(@server, {:push, new_item})
  def pop(), do: GenServer.call(@server, :pop)
  def clear(), do: send(@server, :clear)
end
