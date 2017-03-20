require IEx

defmodule Eltorrent.TorrentParser do

  alias Eltorrent.TorrentInfo
  alias Eltorrent.TorrentFile
  alias Eltorrent.TorrentPieces

  @doc """
    Parses torrent and gets the info from it as a TorrentInfo
  """
  def parse(filename) do
    get_data = File.read!(filename)
    |> Bento.decode()

    case get_data do
      {:ok, data} -> 
        all_pieces = parse_pieces(data)
        
        %TorrentInfo{
          announces: parse_announces(data), 
          files: parse_files(data, all_pieces), 
          pieces: all_pieces,
          info_sha1: info_sha1(data),
        }
      _ -> nil
    end
  end

  defp parse_announces(data) do
    Enum.uniq([data["announce"]] ++ announces_list(data["announce-list"]))
  end

  defp announces_list(list_data) do
    case list_data do
      nil -> []
      xs -> xs
    end
  end

  defp parse_files(data, all_pieces) do
    files_data = data["info"]["files"]
    file_bytes_in_piece = data["info"]["piece length"]
    file_byte_points = [0] ++ Enum.scan(files_data, 0, &(&1["length"] + &2))

    Enum.zip(files_data, file_byte_points)
    |> Enum.map(fn {file, file_byte_start} -> 
      parse_file(file, file_byte_start, all_pieces, file_bytes_in_piece)
    end)
  end

  defp parse_file(file, file_byte_start, all_pieces, file_bytes_in_piece) do
    file_length_in_bytes = file["length"]
    file_byte_end = file_byte_start + file_length_in_bytes

    file = %TorrentFile{
      path: file["path"], 
      length_in_bytes: file_length_in_bytes,
      file_byte_start: file_byte_start,
      file_byte_end: file_byte_end,
      pieces: TorrentPieces.get_all_sha_pieces_for_file(all_pieces, file_byte_start, file_byte_end, file_bytes_in_piece),
    }

    file
  end

  defp parse_pieces(data) do
    TorrentPieces.get_all_sha_pieces_simple(pieces_bytes_list(data))
  end

  defp pieces_bytes_list(data) do
    :binary.bin_to_list(data["info"]["pieces"])
  end

  # defp files_length(data) do
  #   length(data["info"]["files"])
  # end

  defp info_sha1(data) do
    {:ok, info} = data["info"] |> Bento.encode()
    to_encrypt = :binary.bin_to_list(info)
    :crypto.hash(:sha, to_encrypt)
  end
end