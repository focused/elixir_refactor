defmodule Refactor.StackSimpleTest do
  use ExUnit.Case
  alias Refactor.StackServerSimple

  describe "push/1" do
    test "pushes a new item" do
      # assert :sys.get_state(StackServer) == [0, -1]
      :sys.replace_state(StackServerSimple, fn _ -> [] end)

      StackServerSimple.push(1)
      StackServerSimple.push(2)

      assert :sys.get_state(StackServerSimple) == [2, 1]
    end
  end

  describe "pop/0" do
    test "pops item from the head" do
      :sys.replace_state(StackServerSimple, fn _ -> [2, 1] end)

      assert StackServerSimple.pop() == 2
      assert :sys.get_state(StackServerSimple) == [1]

      assert StackServerSimple.pop() == 1
      assert :sys.get_state(StackServerSimple) == []
    end
  end

  describe "handle_info" do
    test "clear" do
      :sys.replace_state(StackServerSimple, fn _ -> [2, 1] end)

      StackServerSimple.clear()
      assert :sys.get_state(StackServerSimple) == []
    end
  end
end
