defmodule Refactor.StackImplTest do
  use ExUnit.Case
  alias Refactor.Stack

  describe "push/1" do
    test "pushes a new item" do
      # assert :sys.get_state(Stack.Server) == [0, -1]
      :sys.replace_state(Stack.Server, fn _ -> [] end)

      Stack.push(1)
      Stack.push(2)

      assert :sys.get_state(Stack.Server) == [2, 1]
    end
  end

  describe "pop/0" do
    test "pops item from the head" do
      :sys.replace_state(Stack.Server, fn _ -> [2, 1] end)

      assert Stack.pop() == 2
      assert :sys.get_state(Stack.Server) == [1]

      assert Stack.pop() == 1
      assert :sys.get_state(Stack.Server) == []
    end
  end

  describe "handle_info" do
    test "clear" do
      :sys.replace_state(Stack.Server, fn _ -> [2, 1] end)

      Stack.clear()
      assert :sys.get_state(Stack.Server) == []
    end
  end
end
