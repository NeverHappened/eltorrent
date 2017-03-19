defmodule Eltorrent.TorrentFile do
  defstruct [:path, :length_in_bytes, :file_byte_start, :file_byte_end, :pieces]
end