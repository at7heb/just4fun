defmodule SameSuit do
  @moduledoc """
  Documentation for `SameSuit`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SameSuit.hello()
      :world

  """
  def hello do
    :world
  end

  def do_parallel do
    me = self()
    _p0 = spawn(fn -> send(me, {:hello, do_a_bunch()}) end)
    _p1 = spawn(fn -> send(me, {:hello, do_a_bunch()}) end)
    _p2 = spawn(fn -> send(me, {:hello, do_a_bunch()}) end)
    _p3 = spawn(fn -> send(me, {:hello, do_a_bunch()}) end)
    _p4 = spawn(fn -> send(me, {:hello, do_a_bunch()}) end)

    (([
        receive do
          {:hello, avg} -> avg
        end
      ] ++
        [
          receive do
            {:hello, avg} -> avg
          end
        ] ++
        [
          receive do
            {:hello, avg} -> avg
          end
        ] ++
        [
          receive do
            {:hello, avg} -> avg
          end
        ] ++
        [
          receive do
            {:hello, avg} -> avg
          end
        ])
     |> Enum.sum()) / 5
     |> IO.inspect()
  end

  def do_a_bunch do
    avg_draw(1_000_000)
  end

  def avg_draw(n) when is_integer(n) and n > 10 do
    total =
      Stream.map(1..n, fn _ -> draw_n(3) end)
      |> Enum.to_list()
      |> Enum.sum()

    total / n
  end

  def draw_n(n) when is_integer(n) and n > 1 and n < 4 do
    shuffled_deck()
    |> Enum.reduce_while(%{}, fn suit, map -> another_card(suit, map, n) end)
    |> Map.values()
    |> Enum.sum()
  end

  def another_card(suit, %{} = map, n) when is_integer(suit) and suit >= 1 and suit <= 4 do
    current_count = Map.get(map, suit, 0) + 1
    new_map = Map.put(map, suit, current_count)

    case current_count do
      ^n -> {:halt, new_map}
      _ -> {:cont, new_map}
    end
  end

  def shuffled_deck do
    make_deck()
    |> Enum.shuffle()
  end

  def make_deck() do
    List.duplicate(1, 13) ++
      List.duplicate(2, 13) ++ List.duplicate(3, 13) ++ List.duplicate(4, 13)
  end
end
