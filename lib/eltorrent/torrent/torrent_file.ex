defmodule Eltorrent.TorrentFile do
  defstruct [:path, :length_in_bytes, :pieces]
end