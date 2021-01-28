defmodule Computer do
  def select_move(board_state, player_team) do
    team = get_team(player_team)

    board_state
    |> try_win(team)
    |> block_player_win(board_state, player_team)
    |> first_move(board_state)
    |> furthest_distance_move(board_state, team)
    |> closest_intersection_move(board_state, team)
  end

  def get_team(:x), do: :o
  def get_team(:o), do: :x

  def try_win(board_state, team) do
    cond do
      not is_nil(get_row_win(board_state, team)) -> get_row_win(board_state, team)
      not is_nil(get_column_win(board_state, team)) -> get_column_win(board_state, team)
      get_diagonal_win(board_state,team) != {nil,nil} -> get_diagonal_win(board_state,team)
    end
  end

  defp get_row_win(board_state, team),
    do:
      board_state
      |> make_board_enumerable()
      |> Enum.map(fn {index, row} -> {check_row_win(row, team), String.to_integer(index)} end)
      |> Enum.find(&(elem(&1, 0) != nil))

  defp check_row_win(row, team) do
    with 2 <- Enum.count(row, &(&1 == team)),
         true <- Enum.any?(row, &(&1 == nil)) do
      Enum.find_index(row, &(&1 == nil))
    else
      _ -> nil
    end
  end

  def get_column_win(board_state, team) do
    [0, 1, 2]
    |> Enum.map(fn index ->
      item0 = Map.get(board_state, "0")
      |> Enum.at(index)

      item1 = Map.get(board_state, "1")
      |> Enum.at(index)

      item2 = Map.get(board_state, "2")
      |> Enum.at(index)

      {check_row_win([item0, item1, item2], team), index}
    end)
    |> Enum.find(fn {col, row} -> is_integer(col) and is_integer(row) end)
 end

  def get_diagonal_win(board_state, team) do
    with {nil, nil} <- check_positive_diagonal(board_state, team) do
      check_negative_diagonal(board_state,team)
    else
      result -> result
    end

  end

  defp check_positive_diagonal(board_state,team) do
    result = board_state
    |> make_board_enumerable()
    |> Enum.map(fn {index, row} -> Enum.at(row, String.to_integer(index)) end)
    |> check_row_win(team)

    {result, result}
  end

  defp check_negative_diagonal(board_state, team) do
    result = board_state
    |> make_board_enumerable()
    |> Enum.map(fn {index, row} -> Enum.at(row, 2 - String.to_integer(index)) end)
    |> check_row_win(team)

    case result do
      0 -> {2,0}
      1 -> {1,1}
      2 -> {0,2}
    end


  end

  def block_player_win(nil, board_state, player_team) do
    try_win(board_state, player_team)
  end

  def block_player_win(curr_move, _, _), do: curr_move

  def first_move(nil, board_state) do
    board_state
    |> make_board_enumerable()
    |> Enum.find(fn {_index, row} -> Enum.any?(row, &(is_nil(&1))) end)
    |> (&({String.to_integer(elem(&1,0)), Enum.find_index(elem(&1,1), fn item -> is_nil(item) end)})).()
  end

  def first_move(curr_move, _), do: curr_move

  defp make_board_enumerable(board_state),
    do:
      board_state
      |> Map.to_list()
      |> Enum.filter(fn {index, _} -> index in ["0","1","2"] end)



  def furthest_distance_move(nil, board_state, team) do
    string_team = Atom.to_string(team)
    [{_col, _row} = move | _] = moves = Map.get(board_state, string_team)

    case Enum.count(moves) do
      1 -> get_furthest_coordinate(move, board_state)
      _ -> nil
    end
  end

  def furthest_distance_move(curr_move, _, _), do: curr_move

  defp get_furthest_coordinate({1,1}, board_state) do
    cond do
      is_nil(get_value(board_state, {0,0})) -> {0,0}
      is_nil(get_value(board_state, {2,0})) -> {2,0}
      is_nil(get_value(board_state, {0,2})) -> {0,2}
      is_nil(get_value(board_state, {2,2})) -> {2,2}

    end
  end

  defp get_furthest_coordinate({col,row}, board_state) do
    far_col = Kernel.abs(2 - col)
    far_row = Kernel.abs(2 - row)

    board_state
    |> get_value({far_col, far_row})
    |> case do
      nil -> {far_col, far_row}
      _ -> get_furthest_coordinate({col ,far_row - 1}, board_state)
    end
  end

  defp get_value(board_state, {col, row}) do
    board_state
    |> Map.get(Integer.to_string(row))
    |> Enum.at(col)
  end




  def closest_intersection_move(nil, board_state, team) do
    [{col0, row0} | tail] = Map.get(board_state, Atom.to_string(team))
    [{col1, row1} | _rest] = tail

    cond do
      Kernel.abs(2 - col0) == col1 and is_nil(get_value(board_state, {col1, row0})) -> {col1, row0}
      Kernel.abs(1 - col0) == col1 and is_nil(get_value(board_state, {col1, row0})) -> {col1, row0}
      Kernel.abs(2 - col1) == col0 and is_nil(get_value(board_state, {col0, row1})) -> {col0, row1}
      Kernel.abs(1 - col1) == col0 and is_nil(get_value(board_state, {col0, row1})) -> {col0, row1}
    end
  end

  def closest_intersection_move(curr_move, _, _), do: curr_move
end
