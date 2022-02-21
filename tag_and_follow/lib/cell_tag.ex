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
       followers: [],
       resources: []
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
      :req_follow_tag -> self() |> Cell.Tag.Util.follow_tag(msg, state)
      :req_un_follow_tag -> self() |> Cell.Tag.Util.un_follow_tag(msg, state)
      :req_get_followers -> self() |> Cell.Tag.Util.get_followers(msg, state)
      :req_add_tag_resource -> self() |> Cell.Tag.Util.add_tag_resource(msg, state)
      :req_get_resources -> self() |> Cell.Tag.Util.get_resources(msg, state)
      _ -> state
    end
  end

end
