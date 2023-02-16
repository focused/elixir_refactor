defmodule Refactor.StackTest do
  use ExUnit.Case
  alias Refactor.StackServer

  describe "push/1" do
    test "pushes a new item" do
      # assert :sys.get_state(StackServer) == [0, -1]
      :sys.replace_state(StackServer, fn _ -> [] end)

      StackServer.push(1)
      StackServer.push(2)

      assert :sys.get_state(StackServer) == [2, 1]
    end
  end

  describe "pop/0" do
    test "pops item from the head" do
      :sys.replace_state(StackServer, fn _ -> [2, 1] end)

      assert StackServer.pop() == 2
      assert :sys.get_state(StackServer) == [1]

      assert StackServer.pop() == 1
      assert :sys.get_state(StackServer) == []
    end
  end

  describe "handle_info" do
    test "clear" do
      :sys.replace_state(StackServer, fn _ -> [2, 1] end)

      StackServer.clear()
      assert :sys.get_state(StackServer) == []
    end
  end
end
