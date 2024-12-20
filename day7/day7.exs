defmodule Day7 do
  def solve do
    File.read!("input.txt")
    |> parse_input()
    |> Enum.filter(&valid_equation?/1)
    |> Enum.map(fn {test_value, _} -> test_value end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [test_value, numbers] = String.split(line, ": ")
      numbers = numbers |> String.split(" ") |> Enum.map(&String.to_integer/1)
      {String.to_integer(test_value), numbers}
    end)
  end

  def valid_equation?({test_value, numbers}) do
    operator_combinations(length(numbers) - 1)
    |> Enum.any?(fn operators ->
      evaluate(numbers, operators) == test_value
    end)
  end

  def operator_combinations(n) do
    for op <- List.duplicate(["+", "*"], n),
        reduce: [[]] do
      acc -> for x <- acc, y <- op, do: x ++ [y]
    end
  end

  def evaluate(numbers, operators) do
    [first | rest] = numbers

    Enum.zip(operators, rest)
    |> Enum.reduce(first, fn {op, num}, acc ->
      case op do
        "+" -> acc + num
        "*" -> acc * num
      end
    end)
  end
end

IO.puts(Day7.solve())
