defmodule Eltorrent.TorrentParser do

  alias Eltorrent.TorrentInfo
  alias Eltorrent.TorrentFile

  @doc """
    Parses torrent and gets the info from it as a Map
  """
  def parse(filename) do
    get_data = File.read!(filename)
    |> Bento.decode()

    case get_data do
      {:ok, data} -> %TorrentInfo{announces: parse_announces(data), files: parse_files(data)}
      _ -> nil
    end
  end

  defp parse_announces(data) do
    [data["announce"]] ++ announces_list(data["announce-list"])
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
    
    pieces_list = :binary.bin_to_list(data["info"]["pieces"])
    # piece_length_in_bytes = data["info"]["piece length"]
    
    sha1_bits_per_block = 160
    sha1_bytes_per_block = sha1_bits_per_block / 8 # 20

    # todo: consider case with only one file

    Enum.with_index(files_data)
    |> Enum.map(fn file_with_index -> parse_file(file_with_index, pieces_list, sha1_bytes_per_block) end)
  end

  defp parse_file({file, index}, pieces_list, sha1_bytes_per_block) do
    # todo: do we need to store index either?
    %TorrentFile{
      path: file["path"], 
      length_in_bytes: file["length"], 
      pieces: extract_pieces_for_this_file(index, pieces_list, sha1_bytes_per_block)
    }
  end

  defp extract_pieces_for_this_file(file_index, pieces_list, sha1_bytes_per_block) do
    # note: we use the fact that files are in the same order that pieces sha's concatenated
    from_byte = round(file_index * sha1_bytes_per_block)
    to_byte = round(Enum.max([from_byte + sha1_bytes_per_block, length(pieces_list)]) - 1)

    Enum.slice(pieces_list, from_byte..to_byte)
  end
end