defmodule Eltorrent.TorrentPieces do

  def get_all_sha_pieces(torrent_file) do
    get_all_sha_pieces_simple(length(torrent_file.files), torrent_file.pieces)
  end

  def get_all_sha_pieces_simple(files_length, pieces) do
    file_indexes = 1..(files_length - 1)

    Enum.map(file_indexes, fn index -> get_sha_pieces(pieces, index) end)
  end

  def get_sha_pieces(pieces, file_index) do
    sha1_bits_per_block = 160
    sha1_bytes_per_block = sha1_bits_per_block / 8 # 20

    # note: we use the fact that files are in the same order that pieces sha's concatenated
    from_byte = round(file_index * sha1_bytes_per_block)
    to_byte = round(Enum.max([from_byte + sha1_bytes_per_block, length(pieces)]) - 1)

    Enum.slice(pieces, from_byte..to_byte)
  end

end