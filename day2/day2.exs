defmodule Day2 do

  def solve() do
    input = File.read!("input.txt")
    safe_lines = input 
    |> String.trim() 
    |> String.split("\n")
    |> Enum.filter(&is_safe_line?/1)
    |> Enum.count()

    # IO.puts(input)
    IO.puts("Number of safe lines: #{safe_lines}")
  end

 def is_safe_line?(line) do
    numbers = line 
    |> String.split() 
    |> Enum.map(&String.to_integer/1)
    
    Enum.any?(0..(length(numbers)-1), fn index ->
      reduced_sequence = List.delete_at(numbers, index)
      is_sequence_valid?(reduced_sequence, :increasing) || 
      is_sequence_valid?(reduced_sequence, :decreasing)
    end)
  end 

  def is_sequence_valid?(numbers, direction) do
      differences = Enum.zip(numbers, Enum.drop(numbers, 1))
      |> Enum.map(fn {a, b} -> 
        case direction do
          :increasing -> b - a
          :decreasing -> a - b
        end
      end)
      
      Enum.all?(differences, &(&1 > 0)) && Enum.all?(differences, &(&1 <= 3))
  end
end

Day2.solve()
