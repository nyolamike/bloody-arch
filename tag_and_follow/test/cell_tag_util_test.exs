defmodule Cell.Tag.Util.Test do
  use ExUnit.Case

  describe "Tag cell util " do
    test "follow_tag -> follows a user by adding the users uuid to the list of followers" do
      receiver = self()
      user_uuid = "4657585"

      initial_state = %{
        followers: []
      }

      request_msg = %{
        name: :req_follow_tag,
        sender: receiver,
        receiver: receiver,
        payload: %{
          uuid: user_uuid
        }
      }

      modified_state =
        Cell.Tag.Util.follow_tag(
          receiver,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_follow_tag,
          payload: %{
            errors: [],
            results: :ok
          },
          receiver: receiver,
          sender: receiver,
          thread: [request_msg]
        }
      }

      assert(modified_state.followers == [user_uuid])
      assert_receive(^expected_res_msg)
    end

    test "un_follow_tag -> unfollows a user from the tag" do
      receiver = self()
      user_uuid = "4657585"

      initial_state = %{
        followers: [user_uuid]
      }

      request_msg = %{
        name: :req_un_follow_tag,
        sender: receiver,
        receiver: receiver,
        payload: %{
          uuid: user_uuid
        }
      }

      modified_state =
        Cell.Tag.Util.un_follow_tag(
          receiver,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_un_follow_tag,
          payload: %{
            errors: [],
            results: :ok
          },
          receiver: receiver,
          sender: receiver,
          thread: [request_msg]
        }
      }

      assert(modified_state.followers == [])
      assert_receive(^expected_res_msg)
    end

    test "get_followers -> returns a list of followers" do
      receiver = self()

      initial_state = %{
        followers: ["4657585", "46575845"]
      }

      request_msg = %{
        name: :req_get_followers,
        sender: receiver,
        receiver: receiver,
        payload: %{}
      }

      un_modified_state =
        Cell.Tag.Util.get_followers(
          receiver,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_get_followers,
          payload: %{
            errors: [],
            results: initial_state.followers
          },
          receiver: receiver,
          sender: receiver,
          thread: [request_msg]
        }
      }

      # the state should not be changes
      assert(un_modified_state == initial_state)

      assert_receive(^expected_res_msg)
    end

    test "add_tag_resource -> adds a uuid of a resource to the list of its resources " do
      receiver = self()
      resource_uuid = "657585"

      initial_state = %{
        resources: []
      }

      request_msg = %{
        name: :req_add_tag_resource,
        sender: receiver,
        receiver: receiver,
        payload: %{
          uuid: resource_uuid
        }
      }

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_add_tag_resource,
          sender: receiver,
          receiver: receiver,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [request_msg]
        }
      }

      modified_state =
        Cell.Tag.Util.add_tag_resource(
          receiver,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      assert(modified_state.resources == [resource_uuid])

      assert_receive(^expected_res_msg)
    end

    test "get_resources -> returns a list of resources uuids" do
      receiver = self()

      initial_state = %{
        resources: ["65784", "75859"]
      }

      request_msg = %{
        name: :req_get_resources,
        sender: receiver,
        receiver: receiver,
        payload: %{}
      }

      un_modified_state =
        Cell.Tag.Util.get_resources(
          receiver,
          request_msg |> Map.put(:thread, []),
          initial_state
        )

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_get_resources,
          sender: receiver,
          receiver: receiver,
          payload: %{
            errors: [],
            results: initial_state.resources
          },
          thread: [request_msg]
        }
      }

      assert(un_modified_state == initial_state)
      assert_receive(^expected_res_msg)
    end
  end
end
