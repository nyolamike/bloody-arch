defmodule Cell.Registry.Tag.Util.Test do
  use ExUnit.Case

  describe "Tag Registry Cell " do
    test "does_tag_exist -> checks if a tag exists" do
      this = self()
      tag1 = "big boys"
      tag2 = "team no sleep"

      initial_state = %{
        tags: [tag1, tag2]
      }

      request_msg = %{
        name: :req_does_tag_exist,
        sender: this,
        receiver: this,
        payload: %{
          name: tag1
        }
      }

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_does_tag_exist,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: true
          },
          thread: [request_msg]
        }
      }

      un_modified_state =
        Cell.Registry.Tag.Util.does_tag_exist(
          this,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      assert(un_modified_state == initial_state)
      assert_receive(^expected_res_msg)
    end
  end
end
