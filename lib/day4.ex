defmodule Day4 do
  def get_input do
    {:ok, result} = File.read("day4.txt")

    [draws | rest] = String.split(result, "\n", trim: true)
    draws = draws |> String.split(",", trim: true) |> Enum.map(fn x -> String.to_integer(x) end)

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

    {draws, boards}
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
      input: board,
      lookup: row_lookup,
      r: %{ 0 => [], 1 => [], 2 => [], 3 => [], 4 => []},
      c: %{ 0 => [], 1 => [], 2 => [], 3 => [], 4 => []},
      total_draws: 0,
      completed: false,
      draws: [],
      hits: [],
      sum: row_lookup |> Map.keys |> Enum.sum
    }
  end

  def draw(board, num) do
    case board[:lookup][num] do
      nil ->
        board
        |> Map.update!(:total_draws, fn x -> x + 1 end)
        |> Map.update!(:draws, fn x -> [num | x] end)

      %{r: r, c: c} ->
        new_r = board[:r] |> Map.update!(r, fn x -> [num | x] end)
        new_c = board[:c] |> Map.update!(c, fn x -> [num | x] end)

        board
        |> Map.update!(:r, fn _ -> new_r end)
        |> Map.update!(:c, fn _ -> new_c end)
        |> Map.update!(:total_draws, fn x -> x + 1 end)
        |> Map.update!(:draws, fn x -> [num | x] end)
        |> Map.update!(:hits, fn x -> [num | x] end)
        |> Map.update!(:sum, fn x -> x - num end)
        |> check_completeness(:r)
        |> check_completeness(:c)
    end
  end

  def check_completeness(board, key) do
    case board[key] |> Enum.find(fn ({_k,v}) -> length(v) == 5 end) do
      nil -> board
      _ -> board |> Map.update!(:completed, fn _ -> true end)
    end
  end

  def run(%{completed: true} = board, _draws) do
    board
  end
  def run(%{completed: false} = board, [num | draws]) do
    next_board = board |> draw(num)
    run(next_board, draws)
  end
  def run(%{completed: false} = board, []) do
    board
  end

  def solve_part1 do
    {draws, boards} = get_input()

    picked_board = boards
    |> Enum.map(fn board -> run(board, draws) end)
    |> Enum.min_by(fn board -> board[:total_draws] end)

    IO.puts("picked #{inspect picked_board}")
    IO.puts("result : #{picked_board[:sum] * hd(picked_board[:draws])}")
  end
end
