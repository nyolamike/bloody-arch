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

  end
end
