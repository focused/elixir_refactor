defmodule Refactor.Stack do
  @moduledoc """
  Stack implementation.
  """

  @type t :: [member]
  @type member :: any

  @spec new(t) :: t
  def new(stack \\ []), do: stack

  @spec push(t, member) :: t
  def push(stack, new_item), do: [new_item | stack]

  @spec pop([member | t]) :: {member, t}
  def pop([head | tail]), do: {head, tail}

  @spec load(t) :: t
  def load(stack), do: new(stack ++ [-1])
end
