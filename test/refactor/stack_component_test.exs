defmodule Refactor.StackComponentTest do
  use ExUnit.Case

  alias Refactor.StackComponent
  alias Refactor.CompStackServer

  describe "push/1" do
    test "pushes a new item" do
      # assert :sys.get_state(Stack) == [0, -1]
      :sys.replace_state(CompStackServer, fn _ -> %StackComponent{items: []} end)

      StackComponent.push(1)
      StackComponent.push(2)

      assert :sys.get_state(CompStackServer) == %StackComponent{items: [2, 1]}
    end
  end

  describe "pop/0" do
    test "pops item from the head" do
      :sys.replace_state(CompStackServer, fn _ -> %StackComponent{items: [2, 1]} end)

      assert StackComponent.pop() == 2
      assert :sys.get_state(CompStackServer) == %StackComponent{items: [1]}

      assert StackComponent.pop() == 1
      assert :sys.get_state(CompStackServer) == %StackComponent{items: []}
    end
  end

  describe "handle_info" do
    test "clear" do
      :sys.replace_state(CompStackServer, fn _ -> %StackComponent{items: [2, 1]} end)

      StackComponent.clear()
      assert :sys.get_state(CompStackServer) == %StackComponent{items: []}
    end
  end
end
