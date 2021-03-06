defmodule Util do
  def send_response(sender, name, body, former_msg) do
    # if the former msg doesnot require a response no message will be sent
    if  former_msg |> Map.has_key?(:noreply) == false do
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
    else
      {:noreply, former_msg}
    end
  end

  def tag_to_process_name(tag_name) do
    proper_name = tag_name |>prep_tag_name()
    {:via, Registry, {TagCellNamesRegistry, proper_name}}
  end

  def tag_to_pid(tag_name) do
    proper_name = tag_name |>prep_tag_name()
    Registry.lookup(TagCellNamesRegistry, proper_name)
  end

  def prep_tag_name(tag_name), do: tag_name |> String.trim() |> String.downcase()
end
