defmodule Day1 do
  def process_input(input) do
    values = for line <- String.split(input, "\n", trim: true),
                 line != "" do
      parts = String.split(line, ~r/\s+/, trim: true)
      
      case parts do
        [left, right] -> 
          {String.to_integer(left), String.to_integer(right)}
        _ -> 
          nil
      end
    end
    
    values = Enum.reject(values, &is_nil/1)
    Enum.unzip(values)
  end

  def calculate_distances({left, right}) do
    left = Enum.sort(left)
    right = Enum.sort(right)

    Enum.zip(left, right)
    |> Enum.map(fn {l, r} -> abs(l - r) end)
  end

  def calculate_similarity_score({left, right}) do
    right_frequencies = Enum.frequencies(right)
    
    left
    |> Enum.map(fn l -> 
      l * Map.get(right_frequencies, l, 0)
    end)
    |> Enum.sum()
  end

  def solve do
    input = File.read!("input.txt")
    {left, right} = process_input(input)

    distances = calculate_distances({left, right})
    total_distance = Enum.sum(distances)
    similarity_score = calculate_similarity_score({left, right})

    # IO.inspect(left)
    # IO.inspect(right) 
    # IO.inspect(distances)
    IO.puts("Total distance: #{total_distance}")
    IO.puts("Similarity score: #{similarity_score}")
  end
end

Day1.solve()
