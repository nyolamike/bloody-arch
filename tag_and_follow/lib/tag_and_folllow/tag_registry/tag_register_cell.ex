defmodule TagRegistry.Cell do
  # get in the genserver behaviour
  use GenServer

  # CLIENT API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :tag_registry_cell, name: __MODULE__)
  end

  ## SEVER CALLBACKS

  def init(_opts) do
    {:ok,
     %{
       name: __MODULE__,
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
      :req_does_tag_exist -> self() |> TagRegistry.Lib.does_tag_exist(msg, state)
      :req_create_tag -> self() |> TagRegistry.Lib.create_tag(msg, state)
      :req_get_tags -> self() |> TagRegistry.Lib.get_tags(msg, state)
      _ -> state
    end
  end
end
