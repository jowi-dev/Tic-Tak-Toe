defmodule ComputerTest do
  use ExUnit.Case

  defp generate_board(rows) do
    %{}
    |> Map.put("0", Keyword.get(rows, :zero, [nil, nil, nil]))
    |> Map.put("1", Keyword.get(rows, :one, [nil, nil, nil]))
    |> Map.put("2", Keyword.get(rows, :two, [nil, nil, nil]))
    |> Map.put("x", Keyword.get(rows, :x, []))
    |> Map.put("o", Keyword.get(rows, :o, []))
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

  describe "furthest_distance_move" do
    test "picks the opposite corner if it is available" do
      assert {2,2} =
        generate_board(zero: [:x, nil, nil], x: [{0,0}])
        |> (&Computer.furthest_distance_move(nil, &1, :x)).()
    end

    test "picks an adjacent space if that space is taken" do
      assert {2,1} =
        generate_board(two: [nil, nil, :o], zero: [:x, nil, nil], x: [{0,0}])
        |> (&Computer.furthest_distance_move(nil, &1, :x)).()
    end

    test "picks a corner if the middle is taken" do
      assert {0,0} =
        generate_board(two: [nil, nil, :o], zero: [nil, nil, nil], x: [{1,1}])
        |> (&Computer.furthest_distance_move(nil, &1, :x)).()

      assert {2,0} =
        generate_board(two: [nil, nil, :o], zero: [:x, nil, nil], x: [{1,1}])
        |> (&Computer.furthest_distance_move(nil, &1, :x)).()

      assert {0,2} =
        generate_board(two: [nil, nil, :o], zero: [:x, nil, :x], x: [{1,1}])
        |> (&Computer.furthest_distance_move(nil, &1, :x)).()

      assert {2,2} =
        generate_board(two: [:x, nil, nil], zero: [:x, nil, :x], x: [{1,1}])
        |> (&Computer.furthest_distance_move(nil, &1, :x)).()
    end
  end

  describe "closest_intersection_move" do
    test "picks a space between the two coordinates that shares a line with each" do
      assert {2,0} =
        generate_board(zero: [:x, nil, nil], one: [nil, :o, nil], two: [nil, nil, :x], x: [{0,0}, {2,2}])
        |> (&Computer.closest_intersection_move(nil, &1, :x)).()
    end
  end
end
