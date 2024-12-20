defmodule Day4 do
  def solve do
    input = File.read!("input.txt")
    grid = parse_input(input)
    count = count_xmas_occurrences(grid)
    IO.puts("XMAS appears #{count} times")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def count_xmas_occurrences(grid) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    for r <- 0..(rows - 1),
        c <- 0..(cols - 1),
        reduce: 0 do
      acc -> acc + count_starting_at(grid, r, c)
    end
  end

  def count_starting_at(grid, start_row, start_col) do
    directions = [
      # right
      {0, 1},
      # down
      {1, 0},
      # diagonal down-right
      {1, 1},
      # diagonal up-right
      {-1, 1},
      # left
      {0, -1},
      # up
      {-1, 0},
      # diagonal up-left
      {-1, -1},
      # diagonal down-left
      {1, -1}
    ]

    Enum.count(directions, fn {dr, dc} ->
      check_xmas(grid, start_row, start_col, dr, dc)
    end)
  end

  def check_xmas(grid, row, col, dr, dc) do
    word = "XMAS"
    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    Enum.with_index(String.graphemes(word))
    |> Enum.all?(fn {char, index} ->
      new_row = row + index * dr
      new_col = col + index * dc

      new_row >= 0 and new_row < rows and
        new_col >= 0 and new_col < cols and
        Enum.at(grid, new_row) |> Enum.at(new_col) == char
    end)
  end
end

Day4.solve()
