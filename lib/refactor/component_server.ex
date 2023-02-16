defmodule Refactor.ComponentServer do
  use GenServer
  require Logger

  def start_link({default, name}) do
    GenServer.start_link(__MODULE__, default, name: name)
  end

  @impl true
  def handle_call(request, from, %module{} = state) do
    {response, new_state} = module.call(state, from, request)
    {:reply, response, new_state}
  end

  @impl true
  def handle_cast(request, %module{} = state) do
    {:noreply, module.cast(state, request)}
  end

  @impl true
  def handle_info(request, %module{} = state) do
    {:noreply, module.info(state, request)}
  end

  # INIT

  @impl true
  def init(state) do
    {:ok, state, {:continue, :load}}
  end

  # OTHER

  @impl true
  def handle_continue(:load, %module{} = state) do
    {:noreply, module.load(state)}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
  end
end
