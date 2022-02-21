defmodule Cell.Util do
  def send_response(sender, name, body, former_msg) do
    resp_msg = %{
      name: name,
      sender: sender,
      receiver: former_msg.sender,
      payload: body,
      thread: [
        %{
          name: former_msg.name,
          sender: former_msg.sender,
          receiver: former_msg.receiver,
          payload: former_msg.payload
        }
        | former_msg.thread
      ]
    }

    GenServer.cast(former_msg.sender, resp_msg)
  end
end
