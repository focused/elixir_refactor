defmodule Refactor.GenComponent do
  def ok(state), do: {:ok, state}

  def ok_continue(state, continue), do: {:ok, state, {:continue, continue}}

  def reply({response, new_state}), do: {:reply, response, new_state}

  def noreply(new_state), do: {:noreply, new_state}

  # TODO: add other common replies (https://hexdocs.pm/elixir/1.14.3/GenServer.html)

  defmacro __using__(opts \\ []) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use GenServer
      import Refactor.GenComponent

      @__component_name__ opts[:name] || __MODULE__

      def start_link(init_state) do
        GenServer.start_link(
          __MODULE__,
          unquote(opts)[:state] || init_state,
          name: @__component_name__
        )
      end

      def call(event, data \\ nil)
      def call(event, nil), do: GenServer.call(@__component_name__, event)
      def call(event, data), do: GenServer.call(@__component_name__, {event, data})

      def cast(event, data), do: GenServer.cast(@__component_name__, {event, data})

      def info(event, data \\ nil)
      def info(event, nil), do: send(@__component_name__, event)
      def info(event, data), do: send(@__component_name__, {event, data})
    end
  end
end
