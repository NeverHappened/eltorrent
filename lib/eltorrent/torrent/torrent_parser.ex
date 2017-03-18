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
      {:ok, data} -> %TorrentInfo{
        announces: parse_announces(data), 
        files: parse_files(data), 
        pieces: parse_pieces(data)
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
      _ -> []
    end
  end

  defp parse_files(data) do
    files_data = data["info"]["files"]
    
    # piece_length_in_bytes = data["info"]["piece length"]
    
    # todo: consider case with only one file

    Enum.with_index(files_data)
    |> Enum.map(fn file_with_index -> parse_file(file_with_index, pieces_list(data)) end)
  end

  defp parse_file({file, index}, pieces_list) do
    # todo: do we need to store index either?
    %TorrentFile{
      path: file["path"], 
      length_in_bytes: file["length"], 
      pieces: TorrentPieces.get_sha_pieces(pieces_list, index)
    }
  end

  defp parse_pieces(data) do
    TorrentPieces.get_all_sha_pieces_simple(files_length(data), pieces_list(data))
  end

  defp pieces_list(data) do
    :binary.bin_to_list(data["info"]["pieces"])
  end

  defp files_length(data) do
    length(data["info"]["files"])
  end
end