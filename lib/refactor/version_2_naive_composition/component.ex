defmodule Refactor.Component do
  @callback call(struct, reference, any) :: {struct, any}
  @callback cast(struct, any) :: struct
  @callback info(struct, any) :: struct
  @callback load(struct) :: struct

  defmacro __using__(opts \\ []) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour Refactor.Component

      @__component_server__ opts[:server]

      def gen_cast(request) do
        GenServer.cast(@__component_server__, request)
      end

      def gen_call(request) do
        GenServer.call(@__component_server__, request)
      end

      def gen_info(request) do
        send(@__component_server__, request)
      end
    end
  end
end
