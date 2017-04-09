defmodule Eltorrent.Peer.PeerSync do
  use GenServer
  # todo: this is basically a GenServer that handles communication with peer
  # todo: initialize it with Tracker.Peer info
  # todo: use Protocol module to orchestrate communication
  @initial_state %{torrent: nil, socket: nil, peer: nil}

  def start_link(torrent, peer) do
    new_state = @initial_state
    |> Map.put(:peer, peer)
    |> Map.put(:torrent, torrent)
    GenServer.start_link(__MODULE__, new_state)
  end

  def handle_call(:handshake, state=%{peer: peer, torrent: torrent}) do
    %{socket: socket} = Protocol.handshake(torrent, peer)
    new_peer_connection = %{socket: socket}
    {:reply, new_peer_connection, %{state | connection: %{socket: socket}}} 
  end
end