require IEx

defmodule Eltorrent.Client do
  use GenServer

  require Logger

  alias Eltorrent.TorrentParser
  alias Eltorrent.Tracker.Request

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
    peer_id = random_binary_string()
    new_state = Map.put(state, :torrent, torrent) |> Map.put(:peer_id, peer_id)
    Logger.info "Starting Client with path '#{torrent_file_path}'"
    {:ok, new_state}
  end

  def handle_call(:start, _from, %{peer_id: peer_id, torrent: torrent}) do
    # todo: move this stuff into its own handle_call
    request = Request.construct_request_model(peer_id, torrent) 
    |> Request.construct_request_params() 
    |> Request.construct_request(torrent)

    response = Tesla.get(request)

    IEx.pry

    # todo: save peer_id in state
  end

  defp random_binary_string do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)
  end

end