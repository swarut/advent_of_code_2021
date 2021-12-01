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

  def process_part1([a| [b | _c] = x], count) when b > a do
    process_part1(x, count + 1)
  end
  def process_part1([a| [b | _c] = x], count) when b <= a do
    process_part1(x, count)
  end
  def process_part1([_x], count) do
    IO.puts("increment = #{count}")
  end
end
