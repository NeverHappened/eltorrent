defmodule Eltorrent.ClientSupervisor do
  use Supervisor

  alias Eltorrent.Client
  alias Eltorrent.Torrent.Parser

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Client, start_params)
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp start_params do
    peer_id = Application.get_env(:eltorrent, :peer_id)
    torrent = Application.get_env(:eltorrent, :torrent_file) |> Parser.parse()
    port = Application.get_env(:eltorrent, :port)
    
    [%{torrent: torrent, peer_id: peer_id, port: port}, Client]
  end
  
end