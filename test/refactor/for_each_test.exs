defmodule Refactor.ForEachTest do
  use ExUnit.Case

  # comment out to test difference =)
  @moduletag :skip

  describe "each" do
    test "" do
      data = [1, 2, -1, 3]

      Enum.each(data, fn n ->
        assert rem(n, 2) == 0
      end)
    end
  end

  describe "for" do
    test "" do
      data = [1, 2, -1, 3]

      for n <- data do
        assert rem(n, 2) == 0
      end
    end
  end
end
