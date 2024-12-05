defmodule Day5 do
  def solve() do
    input = File.read!("input.txt")
    {rules, updates} = parse_input(input)
    
    incorrect_updates = Enum.reject(updates, fn update -> is_valid_order?(update, rules) end)
    
    corrected_updates = Enum.map(incorrect_updates, fn update -> correct_order(update, rules) end)
    
    middle_sum = corrected_updates
    |> Enum.map(fn update -> Enum.at(update, div(length(update) - 1, 2)) end)
    |> Enum.sum()
    
    IO.puts(middle_sum)
  end

  def parse_input(input) do
    [rules_text, updates_text] = String.split(input, "\n\n")
    
    rules = rules_text
    |> String.split("\n")
    |> Enum.map(fn rule -> 
      [x, y] = String.split(rule, "|") |> Enum.map(&String.to_integer/1)
      {x, y}
    end)
    
    updates = updates_text
    |> String.split("\n", trim: true)
    |> Enum.map(fn update -> 
      String.split(update, ",") |> Enum.map(&String.to_integer/1)
    end)
    
    {rules, updates}
  end

  def is_valid_order?(update, rules) do
    Enum.all?(rules, fn {x, y} ->
      cond do
        x not in update or y not in update -> true
        true -> 
          x_index = Enum.find_index(update, &(&1 == x))
          y_index = Enum.find_index(update, &(&1 == y))
          x_index < y_index
      end
    end)
  end

  def correct_order(update, rules) do
    Enum.sort(update, fn a, b ->
      # If there's a rule about a and b, follow it
      case Enum.find(rules, fn {x, y} -> x == a and y == b end) do
        {_, _} -> false  # a must come before b
        nil -> 
          case Enum.find(rules, fn {x, y} -> x == b and y == a end) do
            {_, _} -> true  # b must come before a
            nil -> true     # no rule, keep original order
          end
      end
    end)
  end
end

Day5.solve()
