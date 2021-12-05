defmodule Day4 do
  def get_input do
    {:ok, result} = File.read("day4_test.txt")

    [draws | rest] = String.split(result, "\n", trim: true)

    IO.puts("draws = #{inspect draws}")

    boards = rest
    |> Enum.chunk_every(5)
    |> Enum.map(fn board ->
      board
      |> Enum.map(fn row ->
        row |> String.split(" ", trim: true) |> Enum.map(fn x -> String.to_integer(x) end)
      end)
    end)
    |> Enum.map(fn board ->
      transform_board(board)
    end)
    IO.puts("boards = #{inspect boards}\n\n")
    b = hd(boards)

    c = draw(b, 7)
    IO.puts(inspect(c, charlists: :as_lists))
    c
  end

  def transform_board(board) do
     row_lookup = board
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({line, row}, acc) ->
      line_lookup = line
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({item, col}, line_acc) ->
        line_acc |> Map.put(item, %{r: row, c: col})
      end)
      acc |> Map.merge(line_lookup)
    end)

    %{
      lookup: row_lookup,
      r: %{ 0 => [], 1 => [], 2 => [], 3 => [], 4 => []},
      c: %{ 0 => [], 1 => [], 2 => [], 3 => [], 4 => []},
      total_moves: 0,
      draws: []
    }
  end

  def draw(board, num) do
    case board[:lookup][num] do
      nil ->
        board
        |> Map.update!(:total_moves, fn x -> x + 1 end)
        |> Map.update!(:draws, fn x -> [num | x] end)

      %{r: r, c: c} ->
        new_r = board[:r] |> Map.update!(r, fn x -> [num | x] end)
        new_c = board[:r] |> Map.update!(c, fn x -> [num | x] end)

        board
        |> Map.update!(:r, fn _ -> new_r end)
        |> Map.update!(:c, fn _ -> new_c end)
        |> Map.update!(:total_moves, fn x -> x + 1 end)
        |> Map.update!(:draws, fn x -> [num | x] end)
    end
  end

  # def solve_part1 do
  #   input = get_input()
  #   process_part1(input, 0)
  # end

  # def process_part1([a | [b | _c] = x], count) when b > a do
  #   process_part1(x, count + 1)
  # end

  # def solve_part2 do
  #   input = get_input()
  #   process_part2(input, 3, 0)
  # end

  # def process_part2(x, window, count) when length(x) <= window do
  #   IO.puts("increment = #{count}")
  # end

end


# %{
#   lookup: %{
#     6: %{r: 0, c: 0},
#     10: %{r: 0, c: 3}
#   },
#   r: %{
#     0: [],
#     1: [],
#     2: [],
#     3: [],
#     4: []
#   },
#   c: %{
#     0: [],
#     1: [],
#     2: [],
#     3: [],
#     4: []
#   }
# }
