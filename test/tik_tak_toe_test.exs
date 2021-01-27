defmodule TikTakToeTest do
  use ExUnit.Case
  #doctest TikTakToe

  describe "Team selection" do
    test "the user can select x with X, x" do
      assert :x = TikTakToe.select_team("x")
      assert :x = TikTakToe.select_team("X")
    end

    test "the user can select o with O, o" do
      assert :o = TikTakToe.select_team("o")
      assert :o = TikTakToe.select_team("O")
    end

    test "the user can make any other selection and an auto selection will be made" do
      assert TikTakToe.select_team("Bonkers") in [:o, :x]
      assert TikTakToe.select_team("") in [:o, :x]
    end
  end
end
