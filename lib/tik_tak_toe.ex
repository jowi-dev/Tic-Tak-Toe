defmodule TikTakToe do
  @moduledoc """
  Documentation for `TikTakToe`.
  """

  @doc """
  Play

  ##Generates a board with an X and O on the board, assigns the user to a team and prompts for a move

  ## Examples
      iex> TikTakToe.play()
  """
  def play do
    welcome_prompt()
    |> select_team()
    |> begin_play()
    |> await_move()

    # If the computer is X, the computer plays first
    # Present the board to the user and wait for input
    # If either the computer or the player wins, or it is a draw, display a message noting that
    # Update the board after the user plays with both their play and the computer's next play
  end

  defp begin_play(team) do
    {:ok, pid} = GameState.init(team)

    pid
  end

  def await_move(pid) do
    IO.gets(
      "Make a move selection (x,y format where 0 < x <= 2 and 0 < y <= 2 originating at the bottom left tile) - <Example 1,2>: "
    )
    |> parse_input()
    |> String.split(",")
    |> validate_move(pid)
    |> make_move(pid)
  end

  defp make_move(_move, _pid) do
    IO.puts("making moves")
  end

  defp validate_move(coords, pid) when is_list(coords) do
    cond do
      Enum.count(coords) != 2 -> retry_input(pid)
      Enum.all?(coords, &is_integer/1) -> coords
      true -> retry_input(pid)
    end
  end

  defp retry_input(pid) do
    IO.puts("Invalid input")
    await_move(pid)
  end

  # Welcome message
  defp welcome_prompt() do
    IO.puts("-----Tic TASCII Toe------")
    IO.gets("Select X or O, or skip for random assign (X ALWAYS plays first): ")
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.downcase()
  end

  # Allow user to manually choose teams
  def select_team(result) do
    result
    |> parse_input()
    |> case do
      "x" -> :x
      "o" -> :o
      # If the users opts out of manual selection, auto select
      _ -> auto_assign_team()
    end
    |> IO.inspect(label: "Team Selection")
  end

  defp auto_assign_team() do
    :rand.uniform(10)
    |> (&(&1 > 5)).()
    |> case do
      true -> :x
      false -> :o
    end
  end
end
