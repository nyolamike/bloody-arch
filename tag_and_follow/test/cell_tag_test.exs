defmodule Cell.Tag.Test do
  use ExUnit.Case

  describe "Tag Cell " do

    test "start_link -> spawns a new genserver " do
      tag = "big names"
      {:ok, pid } = Cell.Tag.start_link({tag, []})
      assert Process.alive?(pid)
    end

  end
end
