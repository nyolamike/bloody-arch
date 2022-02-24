defmodule TagRegistry.Lib do
  def does_tag_exist(self, msg, state) do
    # process msg
    # check if a tag is already in the state
    exists = msg.payload.name in state.tags

    # send a response back to the source
    Util.send_response(
      self,
      :res_does_tag_exist,
      %{
        results: exists,
        errors: []
      },
      msg
    )

    # return the  state
    state
  end

  def create_tag(self, msg, state) do
    # process msg
    new_tags =
      case msg.payload.name in state.tags do
        true -> state.tags
        _ -> [msg.payload.name | state.tags]
      end

    # start the tag cell genserver if its not yet started
    case Util.tag_pid(msg.payload.name) do
      [] -> Tag.Cell.start_link(msg.payload.name)
      _ -> :tag_already_started
    end

    # send a response back to the source
    Util.send_response(
      self,
      :res_create_tag,
      %{
        results: :ok,
        errors: []
      },
      msg
    )

    # return the  state
    %{state | tags: new_tags}
  end

  def get_tags(self, msg, state) do
    # process msg
    tags = state.tags

    # send a response back to the source
    Util.send_response(
      self,
      :res_get_tags,
      %{
        results: tags,
        errors: []
      },
      msg
    )

    # return the  state
    state
  end
end
