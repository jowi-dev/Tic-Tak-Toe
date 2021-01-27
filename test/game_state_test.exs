defmodule GameStateTest do
  use ExUnit.Case
  doctest GameState

  describe "init" do
    test "if player is x, return a blank board with player set to x" do
      new_board = GameState.blank_board()
      assert {:ok, %{player: :x, board_state: ^new_board}} = GameState.init(:x)
    end

    test "if player is o, return player set to o and board state with 1 computer move on it" do
    end
  end
end
