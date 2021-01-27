defmodule DisplayTest do
  use ExUnit.Case

  describe "Display Item" do
    test "displays an underscore for a blank space" do
      assert " _ " = Display.display_item(nil)
    end

    test "displays X for for an :x" do
      assert " X " = Display.display_item(:x)
    end

    test "displays O for for an :o" do
      assert " O " = Display.display_item(:o)
    end
  end

  describe "Display Row" do
    test "displays 3 items in a row seperated by spaces" do
      assert " X  _  O " = Display.display_row([:x, nil, :o])
    end
  end

  describe "Display Table" do
    test "displays the rows seperated by a new line" do
      new_board = GameState.blank_board()

      assert " _  _  _ \n _  _  _ \n _  _  _ " = Display.display_board(new_board)
    end

    test "displays row 2 at the top, row 0 at the bottom" do
      assert " _  X  _ \n _  _  _ \n O  _  _ " =
               Display.display_board(%{
                 "2" => [:o, nil, nil],
                 "1" => [nil, nil, nil],
                 "0" => [nil, :x, nil]
               })
    end
  end
end
