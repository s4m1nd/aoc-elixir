defmodule Day6 do
  def solve do
    input = File.read!("input.txt")
    grid = parse_input(input)
    {start_pos, _} = find_guard(grid)

    # Part 1: Get the full path once
    {path, visited} = get_original_path(grid, start_pos, "^", [], MapSet.new())
    part1 = MapSet.size(visited) + 1

    # Part 2: Check positions adjacent to path that create loops
    potential_positions =
      path
      |> Enum.flat_map(fn {pos, _} -> get_adjacent_positions(pos) end)
      |> MapSet.new()
      |> Enum.filter(&is_valid_obstacle?(grid, &1, start_pos))

    part2 = Enum.count(potential_positions, &creates_loop?(grid, start_pos, &1))

    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
    {part1, part2}
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} -> {{y, x}, cell} end)
    end)
    |> Map.new()
  end

  def find_guard(grid), do: Enum.find(grid, fn {_, cell} -> cell == "^" end)

  def get_original_path(grid, pos, dir, path, visited) do
    next_pos = next_position(pos, dir)

    cond do
      !Map.has_key?(grid, next_pos) ->
        {Enum.reverse([{pos, dir} | path]), visited}

      grid[next_pos] == "#" ->
        new_dir = rotate_right(dir)
        get_original_path(grid, pos, new_dir, [{pos, dir} | path], MapSet.put(visited, pos))

      true ->
        get_original_path(grid, next_pos, dir, [{pos, dir} | path], MapSet.put(visited, pos))
    end
  end

  def creates_loop?(grid, start_pos, obstacle_pos) do
    modified_grid = Map.put(grid, obstacle_pos, "#")
    detect_loop(modified_grid, start_pos, "^", MapSet.new())
  end

  def detect_loop(grid, pos, dir, visited) do
    state = {pos, dir}
    next_pos = next_position(pos, dir)

    cond do
      MapSet.member?(visited, state) ->
        true

      !Map.has_key?(grid, next_pos) ->
        false

      grid[next_pos] == "#" ->
        new_dir = rotate_right(dir)
        detect_loop(grid, pos, new_dir, MapSet.put(visited, state))

      true ->
        detect_loop(grid, next_pos, dir, MapSet.put(visited, state))
    end
  end

  def is_valid_obstacle?(grid, pos, start_pos) do
    Map.get(grid, pos) == "." && pos != start_pos
  end

  def get_adjacent_positions({y, x}) do
    [
      {y - 1, x},
      {y + 1, x},
      {y, x - 1},
      {y, x + 1}
    ]
  end

  def next_position({y, x}, dir) do
    case dir do
      "^" -> {y - 1, x}
      ">" -> {y, x + 1}
      "v" -> {y + 1, x}
      "<" -> {y, x - 1}
    end
  end

  def rotate_right(dir) do
    case dir do
      "^" -> ">"
      ">" -> "v"
      "v" -> "<"
      "<" -> "^"
    end
  end
end

Day6.solve()
