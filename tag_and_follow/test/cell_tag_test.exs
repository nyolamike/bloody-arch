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

    test "handle_cast -> processes incoming messages" do
      this = self()
      user = "peter1234"
      initial_state = %{
        followers: [],
        resources: []
      }
      req_follow_msg = %{
        name: :req_follow_tag,
        sender: this,
        receiver: this,
        payload: %{
          uuid: user
        },
        thread: []
      }
      {:noreply, modified_state} = Cell.Tag.handle_cast(req_follow_msg, initial_state)
      IO.inspect(modified_state)
      assert( modified_state.followers == [user] )
    end

    #testing as a genserver
  end
end
