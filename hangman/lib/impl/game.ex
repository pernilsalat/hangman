defmodule Hangman.Impl.Game do
  @moduledoc false

  alias Hangman.Type

  @type t :: %__MODULE__{
               turns_left: integer,
               game_state: Type.state,
               letters: list(String.t),
               used: MapSet.t(String.t),
             }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    Dictionary.random_word |> new_game
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.downcase |> String.codepoints
    }
  end

  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally
  end

  def make_move(game, guess) do
    game
    |> accept_guess(guess, MapSet.member?(game.used, guess))
    |> score_guess(guess)
    |> return_with_tally
  end

  ##################################################

  defp accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end

  defp accept_guess(game, guess, _already_used = false) do
    %{ game | game_state: :evaluating, used: MapSet.put(game.used, guess) }
  end

  ##################################################

  defp score_guess(game = %{ game_state: state }, guess)
      when state != :already_used do
    evaluate_guess(game, guess)
  end
  defp score_guess(game, _guess), do: game

  ##################################################

  defp evaluate_guess(game, guess) when byte_size(guess) == 1 do
    perform_guess(game, guess, Enum.member?(game.letters, guess))
  end

  defp evaluate_guess(game, guess) do
    perform_guess(game, guess, to_string(game.letters) == guess)
  end

  ###################################################

  defp perform_guess(game, guess, _good_guess = true) when byte_size(guess) > 1 do
    %{ game | game_state: :won }
  end
  defp perform_guess(game, _guess, _good_guess = true) do
    new_state = MapSet.new(game.letters)
                |> MapSet.subset?(game.used)
                |> maybe_won
    %{ game | game_state: new_state }
  end

  defp perform_guess(game = %{ turns_left: 1 }, _guess, _good_guess = false) do
    %{ game | game_state: :lost, turns_left: 0 }
  end
  defp perform_guess(game, _guess, _good_guess = false) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end

  ##################################################

  defp return_with_tally(game) do
    { game, tally(game) }
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort,
    }
  end
  
  defp reveal_guessed_letters(game = %{ game_state: game_state}) when game_state in [:lost, :won] do
    game.letters
  end
  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> if MapSet.member?(game.used, letter), do: letter, else: "_" end)
  end

  defp maybe_won(true), do: :won
  defp maybe_won(false), do: :good_guess
end
