defmodule Cli do
  @moduledoc """
  Documentation for `Cli`.
  """

  alias Cli.Impl.Player

  @spec start() :: :ok
  def start do
    Cli.Runtime.RemoteHangman.connect()
    |> Player.start()
  end

end
