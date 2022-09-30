defmodule Cli.Impl.Player do
  @moduledoc false

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)

    interact({ game, tally })
  end

  def interact({ _game, tally = %{ game_state: :won } }) do
    IO.puts "Congratulations! you won! the word was #{ tally.letters |> Enum.join |> String.upcase }"
  end
  
  def interact({ _game, tally = %{ game_state: :lost } }) do
    IO.puts "Sorry, you lost... the word was #{ tally.letters |> Enum.join |> String.upcase }"
  end

  @spec interact(state) :: :ok
  def interact({ game, tally }) do
    # IO.inspect game, label: "game: "
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)

    tally = Hangman.make_move(game, get_guess())
    interact({ game, tally })
  end

  def feedback_for(tally = %{ game_state: :initializing }) do
    "Welcome! I am thinking os a #{ tally.letters |> length } letters word"
  end
  def feedback_for(%{ game_state: :good_guess }), do: IO.ANSI.format([:green, "Good guess!"])
  def feedback_for(%{ game_state: :bad_guess }), do: IO.ANSI.format([:red, "Bad guess!"])
  def feedback_for(%{ game_state: :already_used }), do: "You already used that letter!"

  def current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      IO.ANSI.format([:green, "\tturns left: "]),
      IO.ANSI.format([:blue, tally.turns_left |> to_string]),
      IO.ANSI.format([:green, "\tused so far: "]),
      IO.ANSI.format([:light_yellow, tally.used |> Enum.join(",")]),
    ]
  end
  
  def get_guess() do
    IO.gets("next guess: ")
    |> String.trim()
    |> String.downcase()
  end
  
end
