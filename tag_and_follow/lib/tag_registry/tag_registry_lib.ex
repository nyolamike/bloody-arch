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

  defp spawn_tag(tag_name) do
    tag = tag_name |> String.trim() |> String.downcase() |> String.to_atom()
    #check if there is no process of this tag
    Tag.Cell.start_link({tag, []})
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
