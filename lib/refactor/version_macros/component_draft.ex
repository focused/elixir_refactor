defmodule Refactor.ComponentDraft do
  defmacro defcall(fn_with_args, do: body) do
    {name, _, all_args} = fn_with_args
    [state_arg | rest_args] = Enum.reverse(all_args)
    args = Enum.reverse(rest_args)

    client_request =
      if args != [] do
        quote do
          {unquote(name), unquote_splicing(args)}
        end
      else
        quote do
          unquote(name)
        end
      end

    server_request =
      if args != [] do
        quote do
          {unquote(name), var!(unquote_splicing(args))}
        end
      else
        quote do
          unquote(name)
        end
      end

    quote location: :keep do
      def unquote(name)(unquote_splicing(args)) do
        GenServer.call(@__component_name__, unquote(client_request))
      end

      @impl true
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

  defmacro defcast(fn_with_args, do: body) do
    {name, _, all_args} = fn_with_args
    [state_arg | rest_args] = Enum.reverse(all_args)
    args = Enum.reverse(rest_args)

    quote location: :keep do
      def unquote(name)(unquote_splicing(args)) do
        GenServer.cast(@__component_name__, {unquote(name), unquote_splicing(args)})
      end

      @impl true
      def handle_cast({unquote(name), var!(unquote_splicing(args))}, var!(unquote(state_arg))) do
        new_state = unquote(body)
        {:noreply, new_state}
      end
    end
  end

  defmacro definfo(fn_with_args, do: body) do
    {name, _, all_args} = fn_with_args
    [state_arg | rest_args] = Enum.reverse(all_args)
    args = Enum.reverse(rest_args)

    server_request =
      if args != [] do
        quote do
          {unquote(name), var!(unquote_splicing(args))}
        end
      else
        quote do
          unquote(name)
        end
      end

    quote location: :keep do
      @impl true
      def handle_info(unquote(server_request), var!(unquote(state_arg))) do
        new_state = unquote(body)
        {:noreply, new_state}
      end
    end
  end

  defmacro __using__(opts \\ []) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use GenServer
      import Refactor.ComponentDraft

      @__component_name__ opts[:name] || __MODULE__

      def start_link(init_state) do
        GenServer.start_link(
          __MODULE__,
          unquote(opts)[:state] || init_state,
          name: @__component_name__
        )
      end

      # @impl true
      # def init(state) do
      #   {:ok, state}
      # end
    end
  end
end
