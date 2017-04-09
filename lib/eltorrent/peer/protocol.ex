defmodule Eltorrent.Peer.Protocol do
  # todo: set of functions for protocol communication:
  # handshake and different kinds of messages

  def handshake(torrent, peer, peer_id, info_hash) do
    opts = [:binary, active: false]
    
    {:ok, socket} = :gen_tcp.connect(peer.ip, peer.port, opts)
    # todo: pass handshake over tcp
    # :ok = :gen_tcp.send(socket, Redis.RESP.encode(cmd))
    # `0` means receive all available bytes on the socket.
    # {:ok, msg} = :gen_tcp.recv(socket, 0)
    message_body = prepare_handshake_message(peer_id, info_hash)
    :ok = :gen_tcp.send(socket, message_body)

    %{socket: socket}
  end

  def prepare_handshake_message(peer_id, info_hash) do
    pstrlen = <<19>>
    pstr = "BitTorrent protocol"
    reserved = <<0,0,0,0,0,0,0,0>>

    pstrlen <> pstr <> reserved <> info_hash <> peer_id
  end

  def choke do
    
  end

  def unchoke do
    
  end

  def interested do
    
  end

  def not_interested do
    
  end

  def have do
    
  end

  def bitfield do
    
  end

  def request do
    
  end

  # form: <length prefix><message ID><payload>
  defp send_message(length, message_id, payload) do
    
  end
end