defmodule Eltorrent.TorrentParser do
  @doc """
    Parses torrent and gets the info from it as a Map
  """
  def parse(filename) do
    data = File.read!(filename)
    Bento.decode!(data)
  end
end