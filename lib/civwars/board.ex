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

  def add_player(%__MODULE__{} = board, player) do
    location = find_unoccupied_location(board)
    village = Village.new() |> Village.set_owner(player)

    put_in(board[:villages][location], village)
  end

  def apply_actions(%__MODULE__{} = board, _actions) do
    # TODO: implement
    board
  end

  def advance(%__MODULE__{} = board) do
    board
    |> resolve_moves()
    |> grow_villages()
  end

  defp place_villages(board, 0), do: board
  defp place_villages(board, n) do
    location = find_unoccupied_location(board)
    village = Village.new()

    board_with_villages =
      %{board | villages: Map.put(board.villages, location, village)}

    place_villages(board_with_villages, n - 1)
  end

  defp find_unoccupied_location(board) do
    location = Location.new(:rand.uniform(@height), :rand.uniform(@width))
    if Map.has_key?(board.villages, location) do
      find_unoccupied_location(board)
    else
      location
    end
  end

  defp advance_moves(board) do
    {ongoing, arrived} =
      board.moves
      |> Enum.map(&Move.advance/1)
      |> Enum.split_with(&Move.arrived?/1)

    board_with_moves = %{board | moves: ongoing}

    arrived
    |> Enum.group_by(& &1.to)
    |> Enum.reduce(board_with_moves, &resolve_conflicts/2)
  end

  defp resolve_conflicts([], board), do: board
  defp resolve_conflicts([{location, moves} | rest], board) do
    update_in(board[:villages][location], fn village ->
      Village.attack(village, moves)
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
