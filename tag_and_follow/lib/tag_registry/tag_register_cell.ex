defmodule TagRegistry.Cell do
  # get in the genserver behaviour
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
       tags: []
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
      :req_does_tag_exist -> self() |> Cell.Registry.Tag.Util.does_tag_exist(msg, state)
      :req_create_tag -> self() |> Cell.Registry.Tag.Util.create_tag(msg, state)
      :req_get_tags -> self() |> Cell.Registry.Tag.Util.get_tags(msg, state)
      _ -> state
    end
  end
end
