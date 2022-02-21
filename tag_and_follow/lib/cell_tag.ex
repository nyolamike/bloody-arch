defmodule Cell.Tag do
  # <- this brings in the GenServer behaviour
  use GenServer

  # CLIENT API

  def start_link({tag_name, opts}) do
    GenServer.start_link(__MODULE__, tag_name, opts)
  end

  ## SEVER CALLBACKS

  def init(tag_name) do
    {:ok,
     %{
       name: tag_name,
       followers: []
     }}
  end

  # handling asynchronous requests
  def handle_cast(msg, state) do
    state = handle_message(msg, state)
    {:noreply, state}
  end

  ## SERVER HELPER FUNCTIONS

  defp handle_message(msg, state) do
    case msg.name do
      :req_follow_tag -> follow_tag(msg, state)
      :req_un_follow_tag -> un_follow_tag(msg, state)
      :req_get_followers -> get_followers(msg, state)
      _ -> state
    end
  end

  defp send_response(name, body, former_msg) do
    resp_msg = %{
      name: name,
      sender: self(),
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

  defp follow_tag(msg, state) do
    # process msg
    # check if a users uuid is already here
    new_followers =
      case msg.payload.uuid in state.followers do
        true -> state.followers
        _ -> [msg.payload.uuid | state.followers]
      end
    # send a response back to the source
    send_response(
      :res_follow_tag,
      %{
        results: :ok,
        errors: []
      },
      msg
    )
    # return the new state
    %{state | followers: new_followers}
  end

  defp un_follow_tag(msg, state) do
    # process msg
    # check if a users uuid is already here
    new_followers =
      case msg.payload.uuid in state.followers do
        true -> state.followers |> List.delete(msg.payload.uuid)
        _ -> [msg.payload.uuid | state.followers]
      end
    # send a response back to the source
    send_response(
      :res_un_follow_tag,
      %{
        results: :ok,
        errors: []
      },
      msg
    )
    # return the new state
    %{state | followers: new_followers}
  end

  defp get_followers(msg, state) do
    # process msg
    followers = state.followers
    # send a response back to the source
    send_response(
      :res_get_followers,
      %{
        results: followers,
        errors: []
      },
      msg
    )
    # return the state
    state
  end
end
