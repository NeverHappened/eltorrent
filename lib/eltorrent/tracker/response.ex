defmodule Eltorrent.Tracker.Response do
  # note: peers can be in binary or dictionary model
  defstruct [:failure_reason, :tracker_id, :peers]

  def parse_from(response_raw) do
    # todo
  end
end