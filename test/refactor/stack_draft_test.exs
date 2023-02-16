defmodule Refactor.StackDraftTest do
  use ExUnit.Case
  alias Refactor.StackDraft

  describe "push/1" do
    test "pushes a new item" do
      # assert :sys.get_state(StackDraft) == [0, -1]
      :sys.replace_state(StackDraft, fn _ -> [] end)

      StackDraft.push(1)
      StackDraft.push(2)

      assert :sys.get_state(StackDraft) == [2, 1]
    end
  end

  describe "pop/0" do
    test "pops item from the head" do
      :sys.replace_state(StackDraft, fn _ -> [2, 1] end)

      assert StackDraft.pop() == 2
      assert :sys.get_state(StackDraft) == [1]

      assert StackDraft.pop() == 1
      assert :sys.get_state(StackDraft) == []
    end
  end

  describe "handle_info" do
    test "clear" do
      :sys.replace_state(StackDraft, fn _ -> [2, 1] end)

      send(StackDraft, :clear)
      assert :sys.get_state(StackDraft) == []
    end
  end
end
