defmodule ComputerTest do
  use ExUnit.Case

  defp generate_board(rows) do
    %{}
    |> Map.put("0", Keyword.get(rows, :zero, [nil, nil, nil]))
    |> Map.put("1", Keyword.get(rows, :one, [nil, nil, nil]))
    |> Map.put("2", Keyword.get(rows, :two, [nil, nil, nil]))
  end

  test "get_team/1 returns the opposite of the player_team" do
    assert :o = Computer.get_team(:x)
    assert :x = Computer.get_team(:o)
  end

  describe "select_move/1" do
    test "returns an x,y tuple of the next move a computer will make" do
    end
  end

  describe "try_win/1" do
    test "looks for row wins" do
      assert {1, 0} = generate_board(zero: [:x, nil, :x]) |> Computer.try_win(:x)
      assert {0, 1} = generate_board(one: [nil, :x, :x]) |> Computer.try_win(:x)
      assert {2, 2} = generate_board(two: [:x, :x, nil]) |> Computer.try_win(:x)
    end

    test "looks for column wins" do
      assert {0, 0} =
               generate_board(zero: [nil, nil, nil], one: [:x, nil, nil], two: [:x, nil, nil])
               |> Computer.try_win(:x)

      assert {1, 1} =
               generate_board(zero: [nil, :x, nil], one: [nil, nil, nil], two: [:o, :x, nil])
               |> Computer.try_win(:x)

      assert {2, 2} =
               generate_board(zero: [nil, nil, :x], one: [nil, nil, :x], two: [nil, nil, nil])
               |> Computer.try_win(:x)
    end

    test "looks for diagonal wins" do
      assert {2, 2} =
               generate_board(zero: [:x, nil, nil], one: [nil, :x, nil], two: [nil, nil, nil])
               |> Computer.try_win(:x)

      assert {2, 0} =
               generate_board(zero: [nil, nil, nil], one: [nil, :x, nil], two: [:x, nil, nil])
               |> Computer.try_win(:x)
    end
  end

  describe "block_player_win" do
    test "gets the player team and checks to make sure they can't win" do
      assert {2, 2} =
               generate_board(zero: [:x, nil, nil], one: [nil, :x, nil], two: [nil, nil, nil])
               |> (&Computer.block_player_win(nil, &1, :x)).()
    end
  end

  describe "first_move" do
    test "picks any unclaimed spot on the board for a first move" do
      assert {col, row} =
               generate_board(zero: [:x, nil, nil], one: [nil, :x, nil], two: [nil, nil, nil])
               |> (&Computer.first_move(nil, &1)).()

      assert is_integer(col) and is_integer(row)
    end
  end
end
