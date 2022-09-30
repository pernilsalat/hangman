defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman
  alias Hangman.Impl.Game

  setup do
    {:ok, game: Game.new_game("HELLO") }
  end

  test "new game returns the correct word", state do
    letters = ["h", "e", "l", "l", "o"]

    assert state.game.letters == letters
  end

#  test "new game returns the correct in lower case" do
#    letters = ["w", "o", "m", "b", "a", "t"]
#
#    assert game.letters == letters
#  end
  
  test "state does not change if the game is won or lost", state do
    for game_state <- [:won, :lost] do
      game = state.game |> Map.put(:game_state, game_state)
      { new_game, _tally } = Game.make_move(game, "w")

      assert new_game == game
    end
  end

  test "adding a new letter should update the used attribute of the game", state do
    { game, _tally } = state.game |> Game.make_move("x")

    assert game.used == MapSet.new(["x"])
  end

  test "duplicate letter is reported", state do
    { game, _tally } = state.game |> Game.make_move("x")
    { game, _tally } = game |> Game.make_move("x")

    assert game.game_state == :already_used
  end
  
  test "we recognize letters in the word", state do
    { _game, tally } = state.game |> Game.make_move("h")

    assert tally.game_state == :good_guess
  end

  test "we recognize letters not in the word", state do
    { _game, tally } = state.game |> Game.make_move("x")

    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of moves", state do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
    ]
    |> test_sequence_of_moves(state.game)
  end

  test "can handle a winning game", state do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],

      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
      ["y", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x", "y"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "h", "l", "o", "x", "y"]],
    ]
    |> test_sequence_of_moves(state.game)
  end

  test "can handle a losing game", state do
    [
      ["a", :bad_guess,    6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess,    5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess,    4, ["_", "_", "_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess,    3, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :good_guess,   3, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["f", :bad_guess,    2, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f"]],
      ["g", :bad_guess,    1, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g"]],
      ["h", :good_guess,   1, ["h", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g", "h"]],
      ["i", :lost,         0, ["h", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "f", "g", "h", "i"]],
    ]
    |> test_sequence_of_moves(state.game)
  end


  def test_sequence_of_moves(script, game) do
    Enum.reduce(script, game, &check_one_move/2)
  end
  
  defp check_one_move([guess, game_state, turns_left, letters, used], game) do
    { game, tally } = Game.make_move(game, guess)

    assert tally == %{
             game_state: game_state,
             turns_left: turns_left,
             letters: letters,
             used: used,
           }

    game
  end
end
