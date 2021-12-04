defmodule Day3 do
  def get_input do
    {:ok, result} = File.read("day3.txt")

    String.split(result, "\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, "", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
  end

  def solve_part1 do
    input = get_input()
    one_counts = process_part1(input, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    input_count = length(input)
    gamma_rate_bit = one_counts |> Enum.reduce([], fn (x, acc) ->
      case x > (input_count / 2) do
        true -> ["1" | acc]
        _ -> ["0" | acc]
      end
    end) |> Enum.reverse
    epsilon_rate_bit = one_counts |> Enum.reduce([], fn (x, acc) ->
      case x > (input_count / 2) do
        true -> ["0" | acc]
        _ -> ["1" | acc]
      end
    end) |> Enum.reverse
    IO.puts("gamma_rate_bit = #{inspect gamma_rate_bit}")
    IO.puts("epsilon_rate_bit = #{inspect epsilon_rate_bit}")
    gamma_rate = gamma_rate_bit |> List.to_string |> String.to_integer(2)
    epsilon_rate = epsilon_rate_bit |> List.to_string |> String.to_integer(2)
    gamma_rate * epsilon_rate
  end

  def process_part1([a | b], acc) do
    process_part1(b, count_one(a, acc, []))
  end
  def process_part1([], acc), do: acc

  def count_one([a | b], [c | d], acc) do
    count_one(b, d, [ (a + c) | acc])
  end
  def count_one([], [], acc), do: acc |> Enum.reverse

  def solve_part2 do
    input = get_input()
    one_counts = process_part1(input, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    oxygen = find_oxygen(input, one_counts, 0)
    co2 = find_co2(input, one_counts, 0)
    IO.puts("oxygen = #{oxygen}, co2 = #{co2}")
    oxygen * co2
  end

  def find_oxygen(input, one_counts, position) when length(input) != 1 do
    IO.puts("input = #{inspect(input)}")
    IO.puts("one_counts = #{inspect(one_counts)}")
    next_input = filter_oxygen_input(input, one_counts, position)
    next_one_counts = process_part1(next_input, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    IO.puts("next_input = #{inspect(next_input)}")
    IO.puts("next_one_counts = #{inspect(next_one_counts)}")
    IO.puts("=================================")
    find_oxygen(next_input, next_one_counts, position + 1)
  end
  def find_oxygen(input, _one_counts, _position) when length(input) == 1 do
    hd(input) |> Enum.join |> String.to_integer(2)
  end

  def filter_oxygen_input(input, one_counts, position) do
    count_at_given_position = one_counts |> Enum.at(position)
    IO.puts("count_at_given_position at position #{position} = #{count_at_given_position}")
    input_count = length(input)
    most_common_bit = cond do
      count_at_given_position >= input_count/2 -> 1
      true -> 0
    end
    IO.puts("common bit at position #{position} = #{most_common_bit}")

    input |> Enum.reduce([], fn (x, acc) ->
      bit_at_given_position = x |> Enum.at(position)
      case bit_at_given_position == most_common_bit do
        true -> [x | acc]
        false -> acc
      end
    end)
  end

  def find_co2(input, one_counts, position) when length(input) != 1 do
    IO.puts("input = #{inspect(input)}")
    IO.puts("one_counts = #{inspect(one_counts)}")
    next_input = filter_co2_input(input, one_counts, position)
    next_one_counts = process_part1(next_input, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    IO.puts("next_input = #{inspect(next_input)}")
    IO.puts("next_one_counts = #{inspect(next_one_counts)}")
    IO.puts("=================================")
    find_co2(next_input, next_one_counts, position + 1)
  end
  def find_co2(input, _one_counts, _position) when length(input) == 1 do
    hd(input) |> Enum.join |> String.to_integer(2)
  end

  def filter_co2_input(input, one_counts, position) do
    count_at_given_position = one_counts |> Enum.at(position)
    IO.puts("count_at_given_position at position #{position} = #{count_at_given_position}")
    input_count = length(input)
    least_common_bit = cond do
      count_at_given_position >= input_count/2 -> 0
      true -> 1
    end
    IO.puts("common bit at position #{position} = #{least_common_bit}")

    input |> Enum.reduce([], fn (x, acc) ->
      bit_at_given_position = x |> Enum.at(position)
      case bit_at_given_position == least_common_bit do
        true -> [x | acc]
        false -> acc
      end
    end)
  end
end
