defmodule Eltorrent.Mixfile do
  use Mix.Project

  def project do
    [app: :eltorrent,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [mod: {Eltorrent, []},
     extra_applications: [:logger],
     env: [
       peer_id: generate_peer_id(),
     ]]
  end

  defp deps do
    [{:bento, "0.9.2"},
     {:httpoison, "~> 0.7.3"}]
  end

   # Generate a peer id for the currently running client.
  #
  # Follow an "Azureus-style"-inspired convention for a unique peer id that
  # is exactly 20 bytes long.
  #
  # -RX0.0.1-cf23df2207d9e
  #  ^ ^     ^
  #
  # + T.rex's client abbreviation
  #
  # + Version number
  #   This will be variable length.
  #
  # + Hash
  #   This should fill the remaining bytes in the peer id. It is meant to be
  #   unique and random. The hash will be generated from a part of a SHA1
  #   hash of the running process id (which should be unique enough).

  @client_abbr "RX"
  @peer_id_length 20
  @version "0.0.1"

  defp generate_peer_id do
    hash_length =
      @peer_id_length - (
        1 +
        byte_size(@client_abbr) +
        1 +
        byte_size(@version)
      )

    hash = :crypto.strong_rand_bytes(hash_length)
    "-" <> @client_abbr <> @version <> "-" <> hash
  end
end
