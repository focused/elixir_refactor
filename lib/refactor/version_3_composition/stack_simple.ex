defmodule Refactor.StackSimple do
  def new(stack \\ []), do: stack

  def push(stack, new_item), do: [new_item | stack]

  def pop([head | tail]), do: {head, tail}

  def load(stack), do: new(stack ++ [-1])
end
