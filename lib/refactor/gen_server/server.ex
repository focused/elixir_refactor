defmodule Refactor.GenServer.Server do
  @moduledoc """
  Helper for GenServer functions.
  """

  @type t :: any

  @spec start_link(module, t, keyword) :: GenServer.on_start()
  def start_link(module, state, opts \\ []) do
    name = Keyword.get(opts, :name, module)
    GenServer.start_link(module, state, name: name)
  end

  # child spec?
end
