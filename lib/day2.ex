defmodule Day2 do
  def get_input do
    {:ok, result} = File.read("day2.txt")

    String.split(result, "\n", trim: true)
    |> Enum.map(fn x -> format_input(x) end)
  end

  def format_input(input) do
    [direction, value] = String.split(input, " ", trim: true)
    value = case direction do
      "up" -> -1 * String.to_integer(value)
      _ -> String.to_integer(value)
    end
    [direction, value]
  end

  def solve_part1 do
    input = get_input()
    %{h: h, v: v} = process_part1(input, %{h: 0, v: 0})
    h * v
  end

  def process_part1([["forward", value]| rest], %{h: h, v: v}) do
    process_part1(rest, %{h: h + value, v: v})
  end
  def process_part1([[_, value]| rest], %{h: h, v: v}) do
    process_part1(rest, %{h: h, v: v + value})
  end
  def process_part1([], result), do: result

  def solve_part2 do
    input = get_input()
    %{h: h, v: v, a: _a} = process_part2(input, %{h: 0, v: 0, a: 0})
    h * v
  end

  def process_part2([["forward", value]| rest], %{h: h, v: v, a: a}) do
    process_part2(rest, %{h: h + value, v: v + (value * a), a: a})
  end
  def process_part2([[_, value]| rest], %{h: h, v: v, a: a}) do
    process_part2(rest, %{h: h, v: v, a: a + value})
  end
  def process_part2([], result), do: result
end
