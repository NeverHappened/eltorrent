use Mix.Config

config :eltorrent, torrent_file: System.get_env("TORRENT_FILE")
config :eltorrent, receive_port: "6887" # 6881 - 6889