defmodule Refactor.Stack do
  @moduledoc """
  Stack public API.
  """

  alias Refactor.Stack.Client
  alias Refactor.Stack.Server

  defdelegate push(new_item), to: Client
  defdelegate pop(), to: Client
  defdelegate clear(), to: Client

  defdelegate child_spec(opts), to: Server
  defdelegate start_link(opts), to: Server
end
