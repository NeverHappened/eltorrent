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
    peer_id = Application.get_env(:eltorrent, :peer_id)
    new_state = Map.put(state, :torrent, torrent) |> Map.put(:peer_id, peer_id)
    Logger.info "Starting Client with path '#{torrent_file_path}'"

    {:ok, new_state}
  end

  def handle_call(:start, _from, %{peer_id: peer_id, torrent: torrent}) do
    request_uri = Request.construct_request_model(peer_id, torrent) 
    |> Request.construct_request_params() 
    |> Request.construct_request(torrent)

    case HTTPoison.get(request_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IEx.pry
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        404
      {:error, %HTTPoison.Error{reason: reason}} ->
        IEx.pry
        reason
    end
  end
end