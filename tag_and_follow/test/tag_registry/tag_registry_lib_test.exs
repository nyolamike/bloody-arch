defmodule TagRegistry.Lib.Test do
  use ExUnit.Case

  describe "TagRegistry Lib: " do
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
        TagRegistry.Lib.does_tag_exist(
          this,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      assert(un_modified_state == initial_state)
      assert_receive(^expected_res_msg)
    end

    test "create_tag -> add a tag to the tags list" do
      this = self()
      tag1 = "big boys"
      initial_state = %{
        tags: []
      }
      request_msg = %{
        name: :req_create_tag,
        sender: this,
        receiver: this,
        payload: %{
          name: tag1
        }
      }

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_create_tag,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [request_msg]
        }
      }

      modified_state =
        TagRegistry.Lib.create_tag(
          this,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      assert(modified_state.tags == [tag1])
      assert_receive(^expected_res_msg)


    end

    test "get_tags -> returns the list of tags from the registry" do
      this = self()
      tag1 = "big boys"
      tag2 = "team no sleep"

      initial_state = %{
        tags: [tag1, tag2]
      }

      request_msg = %{
        name: :req_get_tags,
        sender: this,
        receiver: this,
        payload: %{}

      }

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_get_tags,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: initial_state.tags
          },
          thread: [request_msg]
        }
      }

      un_modified_state =
        TagRegistry.Lib.get_tags(
          this,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      assert(un_modified_state == initial_state)
      assert_receive(^expected_res_msg)


    end
  end
end
