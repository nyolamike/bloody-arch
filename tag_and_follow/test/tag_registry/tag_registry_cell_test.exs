defmodule TagRegistry.Cell.Test do
  use ExUnit.Case

  describe "TagRegistry Cell" do
    test "start_link -> starts a genserver" do
      {:ok, pid } = TagRegistry.Cell.start_link()
      is_alive = Process.alive?(pid)
      assert(is_alive == true)
    end
  end

end
