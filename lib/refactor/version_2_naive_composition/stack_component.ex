defmodule Refactor.StackComponent do
  use Refactor.Component, server: Refactor.CompStackServer
  alias __MODULE__

  defstruct items: []

  def new(items), do: %StackComponent{items: items}

  def push(item), do: gen_cast({:push, item})

  def pop, do: gen_call(:pop)

  def clear, do: gen_info(:clear)

  @impl true
  def call(%StackComponent{items: items}, _from, :pop) do
    {hd(items), items |> tl() |> new()}
  end

  @impl true
  def cast(%StackComponent{items: items}, {:push, item}) do
    new([item | items])
  end

  @impl true
  def info(_state, :clear) do
    new([])
  end

  @impl true
  def load(%StackComponent{items: items}) do
    new(items ++ [-1])
  end
end
