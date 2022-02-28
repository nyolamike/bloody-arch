defmodule ResourceRegistry.Cell do
  use GenServer


  #client api
  @spec start_link(opts::[Any])::pid()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # server api

  @impl true
  def init(_opts) do
    {
      :ok,
      %{
        name: __MODULE__,
        resources: []
      }
    }
  end

  def handle_cast(msg, state) do
    state = handle_message(msg, state)
    {:noreply, state}
  end

  ## SERVER HELPER FUNCTIONS

  defp handle_message(msg, state) do
    case msg.name do
      :req_add_tag_resource -> self() |> ResourceRegistry.Lib.add_tag_resource(msg, state)
      :req_get_resources -> self() |> ResourceRegistry.Lib.get_resources(msg, state)
      _ -> state
    end
  end
end
