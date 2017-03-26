require IEx

defmodule Eltorrent.Client do
  use GenServer

  require Logger

  alias Eltorrent.TorrentParser
  alias Eltorrent.Tracker.Request
  alias Eltorrent.Tracker.Response

  def start_link(name) do
    GenServer.start_link(__MODULE__, %{torrent: nil, peer_id: nil, last_response: nil}, name: name)
  end

  def init(state) do
    # note: now it's just testing stuff, later pass torrent_file in state
    torrent_file_path = Application.get_env(:eltorrent, :torrent_file)
    torrent = case torrent_file_path do
      nil -> nil
      path -> TorrentParser.parse(path)
    end
    peer_id = Application.get_env(:eltorrent, :peer_id)
    
    new_state = Map.put(state, :torrent, torrent) 
    |> Map.put(:peer_id, peer_id)
    
    Logger.info "Starting Client with path '#{torrent_file_path}'"
    # GenServer.call(Eltorrent.Client, :sync_with_tracker, 100000)
    {:ok, new_state}
  end

  def handle_call(:sync_with_tracker, _from, state=%{peer_id: peer_id, torrent: torrent}) do
    case get_peers(state) do
      {:ok, response} -> {:reply, response, Map.put(:last_response, response)}
      {:error, reason} -> {:reply, {:error, reason}, Map.put(:last_response, nil)}
    end
  end

  defp get_peers(%{peer_id: peer_id, torrent: torrent}) do
    request_uri = Request.construct_request_model(peer_id, torrent) 
    |> Request.construct_request_params() 
    |> Request.construct_request(torrent)

    case HTTPoison.get(request_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_tracker_response_body(body)}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, 404}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_tracker_response_body(body) do
    result = Eltorrent.Tracker.Response.parse(body)
    []
  end
end