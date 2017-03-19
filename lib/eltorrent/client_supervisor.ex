defmodule Eltorrent.ClientSupervisor do
  use Supervisor

  alias Eltorrent.Client

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Client, [Client])
    ]

    supervise(children, strategy: :one_for_one)
  end
end