defmodule Refactor.GenComponent do
  # TODO: remove `location: :keep`
  # TODO: add other common replies (https://hexdocs.pm/elixir/1.14.3/GenServer.html)

  def ok(state), do: {:ok, state}

  def ok_continue(state, continue), do: {:ok, state, {:continue, continue}}

  def reply({response, new_state}), do: {:reply, response, new_state}

  def noreply(new_state), do: {:noreply, new_state}

  defmacro on_call(fn_with_args, do: body) do
    {name, args, state_arg} = get_definition(fn_with_args)
    client_request = get_client_request(name, args)
    server_request = get_server_request(name, args)

    quote location: :keep do
      def unquote(name)(unquote_splicing(args)) do
        GenServer.call(@__gen_component_name__, unquote(client_request))
      end

      @impl GenServer
      def handle_call(
            unquote(server_request),
            _from,
            var!(unquote(state_arg))
          ) do
        {response, new_state} = unquote(body)
        {:reply, response, new_state}
      end
    end
  end

  defmacro on_cast(fn_with_args, do: body) do
    {name, args, state_arg} = get_definition(fn_with_args)
    client_request = get_client_request(name, args)
    server_request = get_server_request(name, args)

    quote location: :keep do
      def unquote(name)(unquote_splicing(args)) do
        GenServer.cast(@__gen_component_name__, unquote(client_request))
      end

      @impl GenServer
      def handle_cast(unquote(server_request), var!(unquote(state_arg))) do
        new_state = unquote(body)
        {:noreply, new_state}
      end
    end
  end

  defmacro on_info(fn_with_args, do: body) do
    {name, args, state_arg} = get_definition(fn_with_args)
    client_request = get_client_request(name, args)
    server_request = get_server_request(name, args)

    quote location: :keep do
      def unquote(name)(unquote_splicing(args)) do
        send(@__gen_component_name__, unquote(client_request))
      end

      @impl GenServer
      def handle_info(unquote(server_request), var!(unquote(state_arg))) do
        {:noreply, unquote(body)}
      end
    end
  end

  defmacro on_continue(fn_with_args, do: body) do
    {name, args, state_arg} = get_definition(fn_with_args)
    server_request = get_server_request(name, args)

    quote location: :keep do
      @impl GenServer
      def handle_continue(unquote(server_request), var!(unquote(state_arg))) do
        {:noreply, unquote(body)}
      end
    end
  end

  defmacro __using__(opts \\ []) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use GenServer
      import Refactor.GenComponent

      @__gen_component_name__ opts[:name] || __MODULE__

      def start_link(init_state) do
        GenServer.start_link(
          __MODULE__,
          unquote(opts)[:state] || init_state,
          name: @__gen_component_name__
        )
      end

      if opts[:init] do
        @impl GenServer
        def init(state), do: {:ok, state, {:continue, unquote(opts)[:init]}}
      end

      def call(event, data \\ nil)
      def call(event, nil), do: GenServer.call(@__gen_component_name__, event)
      def call(event, data), do: GenServer.call(@__gen_component_name__, {event, data})

      def cast(event, data), do: GenServer.cast(@__gen_component_name__, {event, data})

      def info(event, data \\ nil)
      def info(event, nil), do: send(@__gen_component_name__, event)
      def info(event, data), do: send(@__gen_component_name__, {event, data})
    end
  end

  defp get_definition(fn_with_args) do
    {name, _, all_args} = fn_with_args
    [state_arg | rest_args] = Enum.reverse(all_args)

    {name, Enum.reverse(rest_args), state_arg}
  end

  defp get_client_request(name, args) do
    if args != [] do
      quote do
        {unquote(name), unquote_splicing(args)}
      end
    else
      quote do
        unquote(name)
      end
    end
  end

  defp get_server_request(name, args) do
    case args do
      [_ | _] ->
        quote do
          {unquote(name), var!(unquote_splicing(args))}
        end

      _ ->
        quote do
          unquote(name)
        end
    end
  end
end
