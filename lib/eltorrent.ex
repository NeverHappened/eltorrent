defmodule Eltorrent do
  use Application

  require Logger

  alias Eltorrent.ClientSupervisor

  def start(_type, _args) do
    Logger.info "Starting Client..."
    ClientSupervisor.start_link
  end
end
