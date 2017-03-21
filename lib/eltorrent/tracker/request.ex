require IEx

defmodule Eltorrent.Tracker.Request do
  @doc """
    Sends a HTTP GET request in form of %Request and gets %Response back 
  """
  # event: [started, stopped, completed]
  defstruct [:info_hash, :peer_id, :port, :uploaded, :downloaded, :left, :event, :tracker_id]

  def construct_request_model(peer_id, torrent) do
    %{
      info_hash: torrent.info_sha1,
      peer_id: peer_id,
      port: "6887", # 6881 - 6889
      uploaded: "0"   ,
      downloaded: "0",
      left: "100004", # todo
      event: "started",
    }
  end

  def construct_request_params(request_model) do
    "?" <> URI.encode_query(request_model)
  end

  def construct_request(request_params, torrent) do
    List.first(torrent.announces) <> request_params
  end

  defp param_value_encode({key, value}) do
    # todo: proper encoding of info_hash!
    "#{key}=#{URI.encode(value)}"
  end
end