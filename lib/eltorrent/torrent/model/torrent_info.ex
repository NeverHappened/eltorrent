defmodule Eltorrent.TorrentInfo do
  defstruct [:announces, :files, :pieces, :info_sha1]
end