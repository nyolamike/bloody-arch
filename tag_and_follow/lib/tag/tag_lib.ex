defmodule Tag.Lib do

  def follow_tag(sender, msg, state) do
    # process msg
    # check if a users uuid is already here
    new_followers =
      case msg.payload.uuid in state.followers do
        true -> state.followers
        _ -> [msg.payload.uuid | state.followers]
      end

    # send a response back to the source
    Util.send_response(
      sender,
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

  def un_follow_tag(self, msg, state) do
    # process msg
    # check if a users uuid is already here
    new_followers =
      case msg.payload.uuid in state.followers do
        true -> state.followers |> List.delete(msg.payload.uuid)
        _ -> [msg.payload.uuid | state.followers]
      end

    # send a response back to the source
    Util.send_response(
      self,
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

  def get_followers(sender, msg, state) do
    # process msg
    followers = state.followers
    # send a response back to the source
    Util.send_response(
      sender,
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

  def add_tag_resource(sender, msg, state) do
    # process msg
    # check if a resources uuid is already here
    new_resources =
      case msg.payload.uuid in state.resources do
        true -> state.resources
        _ -> [msg.payload.uuid | state.resources]
      end

    # send a response back to the source
    Util.send_response(
      sender,
      :res_add_tag_resource,
      %{
        results: :ok,
        errors: []
      },
      msg
    )

    # return the new state
    %{state | resources: new_resources}
  end

  def get_resources(sender, msg, state) do
    # process msg
    resources = state.resources

    # send a response back to the source
    Util.send_response(
      sender,
      :res_get_resources,
      %{
        results: resources,
        errors: []
      },
      msg
    )

    # return the new state
    state
  end
end
