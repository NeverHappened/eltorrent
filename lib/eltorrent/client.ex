require IEx

defmodule Eltorrent.Client do
  use GenServer

  require Logger

  alias Eltorrent.Tracker.Sync

  def start_link(%{torrent: torrent, peer_id: peer_id}, name) do
    GenServer.start_link(__MODULE__, %{torrent: torrent, peer_id: peer_id, last_response: nil}, name: name)
  end

  def handle_call(:sync_with_tracker, _from, state=%{peer_id: peer_id, torrent: torrent}) do
    case Sync.sync(%{peer_id: peer_id, torrent: torrent}) do
      {:ok, response} -> {:reply, response, Map.put(state, :last_response, response)}
      {:error, reason} -> {:reply, {:error, reason}, Map.put(state, :last_response, nil)}
    end
  end
end