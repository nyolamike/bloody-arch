defmodule Cell.Tag.Test do
  use ExUnit.Case

  describe "Tag Cell " do
    test "start_link -> spawns a new genserver " do
      tag = :"big names"
      {:ok, pid} = Cell.Tag.start_link({tag, []})
      assert Process.alive?(pid)
    end

    test "init -> returns the initial state of the tag" do
      tag = :"big names"
      exp_initial_state =
        {:ok,
         %{
           name: tag,
           followers: [],
           resources: []
         }}
      ret_state = Cell.Tag.init(tag);

      assert(exp_initial_state == ret_state)
    end
  end
end
