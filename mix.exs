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
     extra_applications: [:logger]]
  end

  defp deps do
    [{:bento, "0.9.2"},
     {:tesla, "~> 0.6.0"}]
  end
end
