defmodule GameState do
  use GenServer
  alias Computer

  @new_board %{
    "2" => [nil, nil, nil],
    "1" => [nil, nil, nil],
    "0" => [nil, nil, nil],
    "x" => [],
    "o" => []
  }

  def blank_board(), do: @new_board

  @impl true
  def init(:x) do
    {:ok,
     %{
       player: :x,
       board_state: @new_board
     }}
  end

  @impl true
  def init(:o) do
    state = %{
      player: :o,
      board_state: @new_board
    }

    board_state = computer_turn(state)

    {:ok, Map.put(state, :board_state, board_state)}
  end

  def handle_call(
        {:player_move, move},
        _from,
        %{player: player_team} = state
      ) do
    state
    |> update_board(move, player_team)
    |> check_match_result()
    |> case do
      {board_state, nil} ->
        board_state
        |> (&Map.put(state, :board_state, &1)).()
        |> computer_turn()
        |> check_match_result()
        |> (&{:reply, &1, state}).()

      {board_state, result} ->
        {:reply, {get_result_message(result), board_state}, nil}
    end
  end

  defp get_result_message(:p), do: "You Won!"
  defp get_result_message(:c), do: "You Lost!"
  defp get_result_message(:d), do: "Draw!"

  defp check_match_result(board_state) do
  end

  defp computer_turn(%{player: p, board_state: board_state} = state) do
    team = Computer.get_team(p)
    move = Computer.select_move(board_state, p)

    update_board(state, move, team)
  end

  defp update_board(%{board_state: board_state}, {x, y} = move, team) do
    updated_row =
      Map.get(board_state, y)
      |> List.replace_at(x, team)

    board_state
    |> Map.put(y, updated_row)
    |> Map.put(Atom.to_string(team), Map.get(board_state, Atom.to_string(team)) ++ [move])
    |> IO.inspect(label: "Updated Board")
  end
end
