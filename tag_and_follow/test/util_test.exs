defmodule Util.Test do
  use ExUnit.Case

  describe "Cell Util " do

    test "send_response -> will send a response messages" do
      this = self()
      req_msg = %{
        name: :req_do_something,
        sender: this,
        receiver: this,
        payload: %{
          uuid: "4567"
        }
      }
      res_msg_name = :res_do_something
      body = %{
        errors: [],
        results: :ok
      }
      exp_res_msg = {
        :"$gen_cast",
        %{
          name: res_msg_name,
          sender: this,
          receiver: this,
          payload: body,
          thread: [req_msg]
        }
      }
      Util.send_response(this, res_msg_name, body, req_msg |> Map.put(:thread, []))

      assert_receive(^exp_res_msg)

    end

    test "send_response -> will not send a message when request message has a  :noreply flag " do
      this = self()
      req_msg = %{
        name: :req_do_something,
        noreply: true
      }
      {:noreply, msg} = Util.send_response(this, :nothing, %{}, req_msg)
      assert(req_msg == msg)
    end

    test "process_name -> prepares a :via tuple to be used by the tagNamesRegistry as a hey for pid lookup" do
      tag = "eliXing Club"
      prep_tag = tag |> String.trim() |> String.downcase()
      expected = {:via, Registry, {TagCellNamesRegistry, prep_tag}}
      result = Util.process_name(tag)
      assert(result == expected)
    end

    test "tag_pid -> looks up the pid of given a tag name, if it does not exist an empty list is returned " do
      tag = "eliXing Club"
      prep_tag = Util.prep_tag_name(tag)
      exp_empty_search_res = Util.tag_pid(tag)
      #create a tag cell genserve
      this = self()
      initial_state = %{
        tags: []
      }
      req_msg = %{
        name: :req_create_tag,
        sender: this,
        receiver: this,
        payload: %{
          name: tag
        },
        thread: []
      }
      modified_state = TagRegistry.Lib.create_tag(this, req_msg, initial_state)
      [{pid, _}] = Util.tag_pid(tag)
      assert(exp_empty_search_res == [])
      assert(modified_state == %{tags: [prep_tag]})
      assert(is_pid(pid))
    end

  end
end
