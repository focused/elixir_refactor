defmodule Refactor.Reply do
  @type t :: any

  @spec ok(t) :: {:ok, t}
  def ok(state), do: {:ok, state}

  @spec ok_continue(t, any) :: {:ok, t, any}
  def ok_continue(state, continue), do: {:ok, state, {:continue, continue}}

  @spec reply({any, t}) :: {:reply, any, t}
  def reply({response, new_state}), do: {:reply, response, new_state}

  @spec noreply(t) :: {:noreply, t}
  def noreply(new_state), do: {:noreply, new_state}
end
