defmodule Civwars.Board do
  alias Civwars.{Location, Move, Village}

  @width 100
  @height 100
  @villages 10

  defstruct [:villages]

  def new do
    %{
      villages: %{},
      moves: []
    }
    |> place_villages(@villages)
  end

  def apply_actions(board, _actions) do
    # TODO: implement
    board
  end

  def advance(board) do
    board
    |> advance_moves()
    |> grow_villages()
  end

  defp place_villages(map, 0), do: map
  defp place_villages(map, n) do
    location = find_unoccupied_location(map)
    village = Village.new()

    map_with_villages =
      %{map | villages: Map.put(map.villages, location, village)}

    place_villages(map_with_villages, n - 1)
  end

  defp find_unoccupied_location(map) do
    location = Location.new(:rand.uniform(@height), :rand.uniform(@width))
    if Map.has_key?(map.villages, location) do
      find_unoccupied_location(map)
    else
      location
    end
  end

  defp advance_moves(%__MODULE__{} = board) do
    {ongoing, arrived} =
      board.moves
      |> Enum.map(&Move.advance/1)
      |> Enum.split_with(&Move.arrived?/1)

    board_with_moves = %{board | moves: ongoing}

    Enum.reduce(arrived, board_with_moves, fn move, b ->
      update_in(b[:villages][move.to], fn village ->
        Village.attack(village, move.owner, move.strenth)
      end)
    end)
  end

  defp grow_villages(board) do
    update_in(board[:villages], fn villages ->
      for {location, village} <- villages, into: %{} do
        {location, Village.grow(village)}
      end
    end)
  end
end
