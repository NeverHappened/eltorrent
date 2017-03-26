defmodule TorrentParserTest do
  use ExUnit.Case
  
  doctest Eltorrent

  test "it gets the data" do
    data = Eltorrent.TorrentParser.parse("~/Downloads/test2.torrent")
  end
end