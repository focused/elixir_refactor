defmodule Refactor.Stack do
  use Refactor.Component, server: Refactor.StackServer
  alias __MODULE__

  defstruct items: []

  def new(items), do: %Stack{items: items}

  def push(item), do: gen_cast({:push, item})

  def pop, do: gen_call(:pop)

  def clear, do: gen_info(:clear)

  @impl true
  def call(%Stack{items: items}, _from, :pop) do
    {hd(items), items |> tl() |> new()}
  end

  @impl true
  def cast(%Stack{items: items}, {:push, item}) do
    new([item | items])
  end

  @impl true
  def info(_state, :clear) do
    new([])
  end

  @impl true
  def load(%Stack{items: items}) do
    new(items ++ [-1])
  end
end
