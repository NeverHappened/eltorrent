defmodule Eltorrent.Tracker.Response do
  # note: peers can be in binary or dictionary model
  defstruct [:failure_reason, :tracker_id, :peers, :interval]

  alias Eltorrent.Tracker.Peer
  alias Eltorrent.Tracker.Response

  def parse(body) do
    {:ok, %{"complete" => complete, "incomplete" => incomplete, "interval" => interval, "min interval" => min_inteval, "peers" => peers}} = Bento.decode(body)
    %Response{peers: parse_peers(peers), interval: interval}
  end

  defp parse_peers(raw_peers) do
    :binary.bin_to_list(raw_peers)
    |> Enum.chunk(6)
    |> Enum.map(fn peer_chunk -> Enum.split(peer_chunk, 4) end)
    |> Enum.map(fn {ip, port} -> %Peer{ip: ip, port: convert_port(port)}  end)
  end

  defp convert_port(raw_port) do
    [a, b] = raw_port
    a * 256 + b
  end
end