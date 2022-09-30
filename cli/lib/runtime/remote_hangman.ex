defmodule Cli.Runtime.RemoteHangman do
  @remote_server :hangman@localhost

  def connect() do
    :rpc.call(@remote_server, Hangman, :new_game, [])
  end
  
end