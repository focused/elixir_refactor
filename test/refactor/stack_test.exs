defmodule Refactor.StackTest do
  use ExUnit.Case
  alias Refactor.StackServerAuto

  describe "push/1" do
    test "pushes a new item" do
      # assert :sys.get_state(StackServerAuto) == [0, -1]
      :sys.replace_state(StackServerAuto, fn _ -> [] end)

      StackServerAuto.push(1)
      StackServerAuto.push(2)

      assert :sys.get_state(StackServerAuto) == [2, 1]
    end
  end

  describe "pop/0" do
    test "pops item from the head" do
      :sys.replace_state(StackServerAuto, fn _ -> [2, 1] end)

      assert StackServerAuto.pop() == 2
      assert :sys.get_state(StackServerAuto) == [1]

      assert StackServerAuto.pop() == 1
      assert :sys.get_state(StackServerAuto) == []
    end
  end

  describe "handle_info" do
    test "clear" do
      :sys.replace_state(StackServerAuto, fn _ -> [2, 1] end)

      StackServerAuto.clear()
      assert :sys.get_state(StackServerAuto) == []
    end
  end
end
