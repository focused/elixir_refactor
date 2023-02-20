defmodule Refactor.GenServer.Reply do
  @moduledoc """
  Helper for standard GenServer replies.
  """

  @type state :: any

  @spec ok(state) :: {:ok, state}
  def ok(state), do: {:ok, state}

  @spec ok_continue(state, any) :: {:ok, state, any}
  def ok_continue(state, continue), do: {:ok, state, {:continue, continue}}

  @spec reply({any, state}) :: {:reply, any, state}
  def reply({response, new_state}), do: {:reply, response, new_state}

  @spec noreply(state) :: {:noreply, state}
  def noreply(new_state), do: {:noreply, new_state}
end
