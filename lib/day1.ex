defmodule Day1 do
  def get_input do
    {:ok, result} = File.read("day1.txt")

    String.split(result, "\n", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1 do
    input = get_input()
    process_part1(input, 0)
  end

  def process_part1([a | [b | _c] = x], count) when b > a do
    process_part1(x, count + 1)
  end
  def process_part1([a | [b | _c] = x], count) when b <= a do
    process_part1(x, count)
  end
  def process_part1([_x], count) do
    IO.puts("increment = #{count}")
  end

  def solve_part2 do
    input = get_input()
    process_part2(input, 3, 0)
  end

  def process_part2(x, window, count) when length(x) <= window do
    IO.puts("increment = #{count}")
  end
  def process_part2([a | b] = x, window, count) do
    first_sum = x |> Enum.take(window) |> Enum.sum()
    second_sum = (x |> Enum.take(window + 1) |> Enum.sum()) - a
    case second_sum > first_sum do
      true -> process_part2(b, window, count + 1)
      _ ->  process_part2(b, window, count)
    end
  end
end
