defmodule Refactor.NomagicStack do
  alias Refactor.NomagicStack.Client
  alias Refactor.NomagicStack.Server

  defdelegate push(new_item), to: Client
  defdelegate pop(), to: Client
  defdelegate clear(), to: Client

  defdelegate child_spec(opts), to: Server
  defdelegate start_link(opts), to: Server
end
