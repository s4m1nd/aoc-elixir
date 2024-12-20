defmodule Day3 do
  def solve do
    input = File.read!("input.txt")
    result = parse_and_calculate(input)
    IO.puts("Calculated result: #{result}")
  end

  def parse_and_calculate(input) do
    input
    |> String.replace(~r/[^a-z0-9(),\[\]]+/, "")
    |> String.replace(["[", "]"], "(")
    |> find_all_expressions()
    |> process_expressions()
    |> Enum.sum()
  end

  defp find_all_expressions(input) do
    Regex.scan(~r/(?:do\(\)|don't\(\)|mul\(\d+,\d+\))/, input)
    |> Enum.map(&hd/1)
  end

  defp process_expressions(expressions) do
    {_, results} =
      Enum.reduce(expressions, {true, []}, fn
        "do()", {_, acc} ->
          {true, acc}

        "don't()", {_, acc} ->
          {false, acc}

        expr, {enabled, acc} ->
          case extract_mul_values(expr) do
            {x, y} when x > 0 and x <= 999 and y > 0 and y <= 999 ->
              if enabled do
                {enabled, [x * y | acc]}
              else
                {enabled, acc}
              end

            _ ->
              {enabled, acc}
          end
      end)

    Enum.reverse(results)
  end

  defp extract_mul_values(expr) do
    case Regex.run(~r/mul\((\d+),(\d+)\)/, expr) do
      [_, x, y] -> {String.to_integer(x), String.to_integer(y)}
      _ -> {0, 0}
    end
  end
end

Day3.solve()
