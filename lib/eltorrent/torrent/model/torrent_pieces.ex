defmodule Eltorrent.TorrentPieces do

  def get_all_sha_pieces(torrent_file) do
    get_all_sha_pieces_simple(torrent_file.pieces)
  end

  def get_all_sha_pieces_simple(pieces) do # pieces - is a list of bytes
    sha1_bytes_per_piece = 160 / 8 # every piece contains 20 bytes
    piece_length = round Float.ceil(length(pieces) / sha1_bytes_per_piece) # how many pieces are there? length / 20
    piece_indexes = 0..(piece_length - 1)

    Enum.map(piece_indexes, fn index -> get_sha_pieces(pieces, index, sha1_bytes_per_piece) end)
  end

  def get_all_sha_pieces_for_file(pieces_list, file_byte_start, file_byte_end, file_bytes_in_piece) do
    start_index = round(Float.ceil(file_byte_start / file_bytes_in_piece))
    end_index = round(Float.ceil(file_byte_end / file_bytes_in_piece)) - 1
    Enum.slice(pieces_list, start_index..end_index)
  end

  def get_sha_pieces(pieces, piece_index, sha1_bytes_per_piece) do
    # note: we use the fact that files are in the same order that pieces sha's concatenated
    from_byte = round(piece_index * sha1_bytes_per_piece)
    to_byte = round(Enum.min([from_byte + sha1_bytes_per_piece, length(pieces)]) - 1)

    Enum.slice(pieces, from_byte..to_byte)
  end
end