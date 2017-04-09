require IEx

defmodule Eltorrent.Client do
  use GenServer

  require Logger

  alias Eltorrent.Tracker.Sync

  def start_link(%{torrent: torrent, peer_id: peer_id, port: port}, name) do
    start_state = %{torrent: torrent, peer_id: peer_id, port: port, connected_peers: [], last_response: nil}
    GenServer.start_link(__MODULE__, start_state, name: name)
  end

  def handle_call(:sync_with_tracker, _from, state=%{peer_id: peer_id, torrent: torrent, port: port}) do
    case Sync.sync(%{peer_id: peer_id, torrent: torrent, port: port}) do
      {:ok, response} -> {:reply, response, Map.put(state, :last_response, response)}
      {:error, reason} -> {:reply, {:error, reason}, Map.put(state, :last_response, nil)}
    end
  end

  def handle_call(
      :handle_incoming_peer_connections, 
      _from, 
      state=%{peer_id: peer_id, torrent: torrent, port: port, connected_peers: connected_peers}) do

    # todo: handle incoming connections on port: port
    :ok = IncomingProtocol.wait_for_handshakes(%{peer_id: peer_id, port: port, torrent: torrent})

    {:reply, :ok, state}
  end

  def handle_call({:add_connected_peer, new_peer_connection}, _from, state=%{connected_peers: connected_peers}) do
    {:reply, :ok, %{state | connected_peers: [new_peer_connection | connected_peers]}}
  end

  def handle_call({:remove_connected_peer, other_peer_id}, _from, state=%{connected_peers: _connected_peers}) do
    # todo: find the peer in peers by peer_id hash (or something else) and remove it
    {:reply, :ok, state}
  end
end