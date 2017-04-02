defmodule TorrentParserTest do
  use ExUnit.Case
  
  doctest Eltorrent

  test "it gets the data" do
    data = Eltorrent.Torrent.Parser.parse("~/Downloads/test2.torrent")
     # GenServer.call(Eltorrent.Client, :sync_with_tracker, 100000)
  end
end