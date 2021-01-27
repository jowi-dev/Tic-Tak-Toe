defmodule Display do
  def display_board(board_state) do
    board_state
    |> Map.to_list()
    |> Enum.filter(fn {_, row} -> is_list(row) end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(fn {_, row} -> display_row(row) end)
    |> Enum.join("\n")
  end

  def display_row(row) when is_list(row),
    do: Enum.reduce(row, "", fn item, acc -> acc <> display_item(item) end)

  def display_row(_), do: "ROWERROR"

  def display_item(nil), do: " _ "
  def display_item(:x), do: " X "
  def display_item(:o), do: " O "
  def display_item(_), do: "ITEMERROR"
end
