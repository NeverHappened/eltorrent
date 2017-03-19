defmodule Eltorrent.Client do
  use GenServer

  require Logger

  alias Eltorrent.TorrentParser

  def start_link(name) do
    GenServer.start_link(__MODULE__, %{torrent: nil}, name: name)
  end

  def init(state) do
    # note: now it's just testing stuff
    torrent_file_path = Application.get_env(:eltorrent, :torrent_file)

    torrent = case torrent_file_path do
      nil -> nil
      path -> TorrentParser.parse(path)
    end

    Logger.info "Starting Client with path '#{torrent_file_path}'"

    {:ok, %{state | torrent: torrent}}
  end

  # todo: start of seeding/peering of torrent

end