defmodule TagRegistry.Cell.Test do
  use ExUnit.Case

  describe "TagRegistry Cell" do
    test "start_link -> starts a genserver" do
      {:ok, pid } = TagRegistry.Cell.start_link([])
      is_alive = Process.alive?(pid)
      assert(is_alive == true)
    end

    test "init -> returns the initial state of the tagRgeistry cell" do
      exp_initial_state =
        {:ok,
         %{
           name: TagRegistry.Cell,
           tags: []
         }}

      ret_state = TagRegistry.Cell.init([])

      assert(exp_initial_state == ret_state)
    end

    test "handle_cast -> handles incoming message requests" do
      this = self()
      #chcking if a tag exists
      tag = "eliXing code"
      tag2 = "Bloody Arch"
      prep_tag = Util.prep_tag_name(tag)
      prep_tag2 = Util.prep_tag_name(tag2)
      initial_state = %{
        tags: [prep_tag]
      }
      req_does_tag_exist_msg = %{
        name: :req_does_tag_exist,
        sender: this,
        receiver: this,
        payload: %{
          name: tag
        },
        thread: []
      }
      exp_res_does_tag_exist_msg = {
        :"$gen_cast",
        %{
          name: :res_does_tag_exist,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: true
          },
          thread: [ req_does_tag_exist_msg |> Map.delete(:thread) ]
        }
      }
      {:noreply, un_modified_state } = TagRegistry.Cell.handle_cast(req_does_tag_exist_msg, initial_state)

      #requsting a tag which does not exist
      req_does_tag_exist_msg_not_exists = %{
        name: :req_does_tag_exist,
        sender: this,
        receiver: this,
        payload: %{
          name: "this tag does not exist"
        },
        thread: []
      }
      exp_res_does_tag_exist_msg_not_exists = {
        :"$gen_cast",
        %{
          name: :res_does_tag_exist,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: false
          },
          thread: [ req_does_tag_exist_msg_not_exists |> Map.delete(:thread) ]
        }
      }
      {:noreply, un_modified_state2 } = TagRegistry.Cell.handle_cast(req_does_tag_exist_msg_not_exists, un_modified_state)


      #create a tag
      req_create_tag_msg = %{
        name: :req_create_tag,
        sender: this,
        receiver: this,
        payload: %{
          name: tag2
        },
        thread: []
      }
      exp_res_create_tag_msg = {
        :"$gen_cast",
        %{
          name: :res_create_tag,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [ req_create_tag_msg |> Map.delete(:thread) ]
        }
      }

      {:noreply, modified_state } = TagRegistry.Cell.handle_cast(req_create_tag_msg, un_modified_state2)

      #geting tags
      req_get_tags_msg = %{
        name: :req_get_tags,
        sender: this,
        receiver: this,
        payload: %{},
        thread: []
      }
      exp_req_get_tags_msg_msg = {
        :"$gen_cast",
        %{
          name: :res_get_tags,
          sender: this,
          receiver: this,
          payload: %{
            errors: [],
            results: modified_state.tags
          },
          thread: [ req_get_tags_msg |> Map.delete(:thread) ]
        }
      }

      {:noreply, un_modified_state3 } = TagRegistry.Cell.handle_cast(req_get_tags_msg, modified_state)

      #unkown message pattern, should not change state
      req_get_tags_msg = %{
        name: :req_unknown_msg,
        sender: this,
        receiver: this,
        payload: %{
          uuid: "48595"
        },
        thread: []
      }
      {:noreply, un_modified_state4 } = TagRegistry.Cell.handle_cast(req_get_tags_msg, un_modified_state3)

      assert(un_modified_state == initial_state)
      assert_receive(^exp_res_does_tag_exist_msg)
      assert(un_modified_state2 == un_modified_state)
      assert_receive(^exp_res_does_tag_exist_msg_not_exists)
      assert(modified_state == %{tags: [prep_tag2, prep_tag] })
      assert_receive(^exp_res_create_tag_msg)
      assert(un_modified_state3 == modified_state)
      assert_receive(^exp_req_get_tags_msg_msg)
      assert(un_modified_state4 == un_modified_state3)

    end

    test "genserver -> process messages like a genserver" do
      this = self()
      tag = "eliXing code"
      {:ok, tag_registry_cell_pid} = TagRegistry.Cell.start_link([])
      #create a tag
      req_create_tag_msg = %{
        name: :req_create_tag,
        sender: this,
        receiver: tag_registry_cell_pid,
        payload: %{
          name: tag
        },
        thread: []
      }
      exp_res_create_tag_msg = {
        :"$gen_cast",
        %{
          name: :res_create_tag,
          sender: tag_registry_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [ req_create_tag_msg |> Map.delete(:thread) ]
        }
      }
      GenServer.cast(tag_registry_cell_pid, req_create_tag_msg)

      #check if a tag exists
      req_does_tag_exist_msg = %{
        name: :req_does_tag_exist,
        sender: this,
        receiver: tag_registry_cell_pid,
        payload: %{
          name: tag
        },
        thread: []
      }
      exp_res_does_tag_exist_msg = {
        :"$gen_cast",
        %{
          name: :res_does_tag_exist,
          sender: tag_registry_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: true
          },
          thread: [ req_does_tag_exist_msg |> Map.delete(:thread) ]
        }
      }

      GenServer.cast(tag_registry_cell_pid, req_does_tag_exist_msg)

      #requsting a tag which does not exist
      req_does_tag_exist_msg_not_exists = %{
        name: :req_does_tag_exist,
        sender: this,
        receiver: tag_registry_cell_pid,
        payload: %{
          name: "this tag does not exist"
        },
        thread: []
      }
      exp_res_does_tag_exist_msg_not_exists = {
        :"$gen_cast",
        %{
          name: :res_does_tag_exist,
          sender: tag_registry_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: false
          },
          thread: [ req_does_tag_exist_msg_not_exists |> Map.delete(:thread) ]
        }
      }

      GenServer.cast(tag_registry_cell_pid, req_does_tag_exist_msg_not_exists)

      #trying to create a tag which already exists should not change state
      req_create_tag_msg_already_exists = %{
        name: :req_create_tag,
        sender: this,
        receiver: tag_registry_cell_pid,
        payload: %{
          name: tag
        },
        thread: []
      }
      exp_res_create_tag_msg_already_exists = {
        :"$gen_cast",
        %{
          name: :res_create_tag,
          sender: tag_registry_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: :ok
          },
          thread: [ req_create_tag_msg_already_exists |> Map.delete(:thread) ]
        }
      }
      GenServer.cast(tag_registry_cell_pid, req_create_tag_msg_already_exists)

      #get tags should return one tag, even though we tried to recreate it
      req_get_tags_msg = %{
        name: :req_get_tags,
        sender: this,
        receiver: tag_registry_cell_pid,
        payload: %{},
        thread: []
      }
      exp_req_get_tags_msg_msg = {
        :"$gen_cast",
        %{
          name: :res_get_tags,
          sender: tag_registry_cell_pid,
          receiver: this,
          payload: %{
            errors: [],
            results: [Util.prep_tag_name(tag)]
          },
          thread: [ req_get_tags_msg |> Map.delete(:thread) ]
        }
      }
      GenServer.cast(tag_registry_cell_pid, req_get_tags_msg)



      assert_receive(^exp_res_create_tag_msg)
      #check if the created tag gnserve is existing
      [{pid, _}] = Util.tag_to_pid(tag)
      is_alive = Process.alive?(pid)
      assert(is_alive == true)
      assert_receive(^exp_res_does_tag_exist_msg)
      assert_receive(^exp_res_does_tag_exist_msg_not_exists)
      assert_receive(^exp_res_create_tag_msg_already_exists)
      assert_receive(^exp_req_get_tags_msg_msg)

    end
  end

end
