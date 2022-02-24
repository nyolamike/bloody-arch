defmodule Tag.Cell.Test do
  use ExUnit.Case

  describe "Tag Cell " do
    test "start_link -> spawns a new genserver " do
      tag = "big names"
      {:ok, pid} = Tag.Cell.start_link(tag)
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

      ret_state = Tag.Cell.init(tag)

      assert(exp_initial_state == ret_state)
    end

    test "handle_cast -> processes incoming messages" do
      this = self()
      user_uuid = "peter1234"
      user_uuid2 = "sam56789"

      initial_state = %{
        followers: [],
        resources: []
      }

      # following a tag
      req_follow_msg = %{
        name: :req_follow_tag,
        sender: this,
        receiver: this,
        payload: %{
          uuid: user_uuid
        },
        thread: []
      }

      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_follow_tag,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_follow_msg |> Map.delete(:thread)]
        }
      }

      {:noreply, modified_state} = Tag.Cell.handle_cast(req_follow_msg, initial_state)

      req_follow_msg2 = %{
        name: :req_follow_tag,
        sender: this,
        receiver: this,
        payload: %{
          uuid: user_uuid2
        },
        thread: []
      }

      expected_res_msg2 = {
        :"$gen_cast",
        %{
          name: :res_follow_tag,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_follow_msg2 |> Map.delete(:thread)]
        }
      }

      {:noreply, modified_state} = Tag.Cell.handle_cast(req_follow_msg2, modified_state)
      assert(modified_state.followers == [user_uuid2, user_uuid])
      assert_received(^expected_res_msg)
      assert_received(^expected_res_msg2)

      # un following a tag
      req_un_follow_tag_msg = %{
        name: :req_un_follow_tag,
        sender: this,
        receiver: this,
        payload: %{
          uuid: user_uuid
        },
        thread: []
      }

      expected_res_msg3 = {
        :"$gen_cast",
        %{
          name: :res_un_follow_tag,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_un_follow_tag_msg |> Map.delete(:thread)]
        }
      }

      {:noreply, modified_state} = Tag.Cell.handle_cast(req_un_follow_tag_msg, modified_state)
      assert(modified_state.followers == [user_uuid2])
      assert_received(^expected_res_msg3)

      # getting tag followers
      req_get_followers_msg = %{
        name: :req_get_followers,
        sender: this,
        receiver: this,
        payload: %{},
        thread: []
      }

      expected_res_msg4 = {
        :"$gen_cast",
        %{
          name: :res_get_followers,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: [user_uuid2]
          },
          thread: [req_get_followers_msg |> Map.delete(:thread)]
        }
      }

      {:noreply, un_modified_state} = Tag.Cell.handle_cast(req_get_followers_msg, modified_state)
      assert(un_modified_state == modified_state)
      assert_received(^expected_res_msg4)

      # adding a tag resource
      resource_uuid = "5363839309"

      req_add_tag_resource_msg = %{
        name: :req_add_tag_resource,
        sender: this,
        receiver: this,
        payload: %{
          uuid: resource_uuid
        },
        thread: []
      }

      expected_res_msg5 = {
        :"$gen_cast",
        %{
          name: :res_add_tag_resource,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_add_tag_resource_msg |> Map.delete(:thread)]
        }
      }

      {:noreply, modified_state} = Tag.Cell.handle_cast(req_add_tag_resource_msg, modified_state)
      assert(modified_state.resources == [resource_uuid])
      assert_received(^expected_res_msg5)

      # get resources from a tag
      req_get_resources_msg = %{
        name: :req_get_resources,
        sender: this,
        receiver: this,
        payload: %{},
        thread: []
      }

      expected_res_msg6 = {
        :"$gen_cast",
        %{
          name: :res_get_resources,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: [resource_uuid]
          },
          thread: [req_get_resources_msg |> Map.delete(:thread)]
        }
      }

      {:noreply, un_modified_state} = Tag.Cell.handle_cast(req_get_resources_msg, modified_state)
      assert(un_modified_state == modified_state)
      assert_received(^expected_res_msg6)

      # un unkown message will just return the state unmodifies
      {:noreply, un_modified_state} =
        Tag.Cell.handle_cast(
          %{
            name: :req_un_kown_msg
          },
          modified_state
        )

      assert(un_modified_state == modified_state)
    end

    # testing the tag cell as a Gen Server
    test "genserver -> processes incoming messages" do
      this = self()
      tag = "actor model framework"
      {:ok, tag_cell_pid} = Tag.Cell.start_link(tag)

      user_uuid = "usr20217484909"
      user_uuid2 = "usr20217753034"
      req_follow_msg = %{
        name: :req_follow_tag,
        sender: this,
        receiver: tag_cell_pid,
        payload: %{
          uuid: user_uuid
        },
        thread: []
      }
      expected_res_msg = {
        :"$gen_cast",
        %{
          name: :res_follow_tag,
          sender: tag_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_follow_msg |> Map.delete(:thread)]
        }
      }

      # send another follow request
      req_follow_msg2 = %{
        name: :req_follow_tag,
        sender: this,
        receiver: tag_cell_pid,
        payload: %{
          uuid: user_uuid2
        },
        thread: []
      }
      expected_res_msg2 = {
        :"$gen_cast",
        %{
          name: :res_follow_tag,
          sender: tag_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_follow_msg2 |> Map.delete(:thread)]
        }
      }

      # un following a tag
      req_un_follow_tag_msg = %{
        name: :req_un_follow_tag,
        sender: this,
        receiver: tag_cell_pid,
        payload: %{
          uuid: user_uuid
        },
        thread: []
      }

      expected_res_msg3 = {
        :"$gen_cast",
        %{
          name: :res_un_follow_tag,
          sender: tag_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_un_follow_tag_msg |> Map.delete(:thread)]
        }
      }

      # getting tag followers
      req_get_followers_msg = %{
        name: :req_get_followers,
        sender: this,
        receiver: tag_cell_pid,
        payload: %{},
        thread: []
      }

      expected_res_msg4 = {
        :"$gen_cast",
        %{
          name: :res_get_followers,
          sender: tag_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: [user_uuid2]
          },
          thread: [req_get_followers_msg |> Map.delete(:thread)]
        }
      }

      # adding a tag resource
      resource_uuid = "5363839309"

      req_add_tag_resource_msg = %{
        name: :req_add_tag_resource,
        sender: this,
        receiver: tag_cell_pid,
        payload: %{
          uuid: resource_uuid
        },
        thread: []
      }

      expected_res_msg5 = {
        :"$gen_cast",
        %{
          name: :res_add_tag_resource,
          sender: tag_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [req_add_tag_resource_msg |> Map.delete(:thread)]
        }
      }

      # get resources from a tag
      req_get_resources_msg = %{
        name: :req_get_resources,
        sender: this,
        receiver: tag_cell_pid,
        payload: %{},
        thread: []
      }

      expected_res_msg6 = {
        :"$gen_cast",
        %{
          name: :res_get_resources,
          sender: tag_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: [resource_uuid]
          },
          thread: [req_get_resources_msg |> Map.delete(:thread)]
        }
      }






      GenServer.cast(tag_cell_pid, req_follow_msg)
      GenServer.cast(tag_cell_pid, req_follow_msg2)
      GenServer.cast(tag_cell_pid, req_un_follow_tag_msg)
      GenServer.cast(tag_cell_pid, req_get_followers_msg)
      GenServer.cast(tag_cell_pid, req_add_tag_resource_msg)
      GenServer.cast(tag_cell_pid, req_get_resources_msg)
      # un unkown message will just return the state unmodifies
      GenServer.cast(tag_cell_pid, %{ name: :req_un_kown_msg })

      assert_receive(^expected_res_msg)
      assert_receive(^expected_res_msg2)
      assert_receive(^expected_res_msg3)
      assert_receive(^expected_res_msg4)
      assert_receive(^expected_res_msg5)
      assert_receive(^expected_res_msg6)


    end
  end
end
