defmodule Refactor.Server do
  @type t :: any

  @spec start_link(t, keyword()) :: GenServer.on_start()
  def start_link(module, state, opts \\ []) do
    name = Keyword.get(opts, :name, module)
    GenServer.start_link(module, state, name: name)
  end

  @spec ok(t) :: {:ok, t}
  def ok(state), do: {:ok, state}

  @spec ok_continue(t, any) :: {:ok, t, any}
  def ok_continue(state, continue), do: {:ok, state, {:continue, continue}}

  @spec reply({any, t}) :: {:reply, any, t}
  def reply({response, new_state}), do: {:reply, response, new_state}

  @spec noreply(t) :: {:noreply, t}
  def noreply(new_state), do: {:noreply, new_state}
end
