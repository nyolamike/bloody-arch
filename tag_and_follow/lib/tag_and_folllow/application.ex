defmodule TagAndFollow.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: TagCellNamesRegistry}
    ]
    opts = [strategy: :one_for_one, name: TagAndFollow.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
