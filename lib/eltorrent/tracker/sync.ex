defmodule Eltorrent.Tracker.Sync do

  alias Eltorrent.Tracker.Request
  alias Eltorrent.Tracker.Response

  def sync(%{peer_id: peer_id, torrent: torrent, port: port}) do
    request_uri = Request.construct_request_model(peer_id, torrent, port) 
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
    result = Response.parse(body)
    # todo
    []
  end
end