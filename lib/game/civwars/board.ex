defmodule Civwars.Board do
  alias Civwars.{Location, Move, Village}

  @derive Jason.Encoder
  defstruct [:villages, :moves]

  @width 100
  @height 100
  @villages 4

  def new do
    %__MODULE__{
      villages: %{},
      moves: []
    }
    |> place_villages(@villages)
  end

  def spawn(%__MODULE__{} = board, player) do
    village =
      board
      |> find_unoccupied_location()
      |> Village.new()
      |> Village.set_owner(player)

    add_village(board, village)
  end

  def move(%__MODULE__{} = board, player, from, to) do
    source = Map.get(board.villages, from)
    target = Map.get(board.villages, to)

    with :ok <- validate_source_village(source, player),
         :ok <- validate_target_village(target),
         distance <- Location.distance(source.location, target.location) do

      {source_without_units, units} = Village.recruit_attack_party(source)

      move = Move.new(to, distance, units, player)

      new_board =
        %{
          board |
          moves: [move | board.moves],
          villages: Map.put(board.villages, from, source_without_units)
        }

      {:ok, new_board}
    else
      msg -> {msg, board}
    end
  end

  def advance(%__MODULE__{} = board) do
    board
    |> grow_villages()
    |> resolve_moves()
  end

  defp place_villages(board, 0), do: board
  defp place_villages(board, n) do
    village =
      board
      |> find_unoccupied_location()
      |> Village.new()

    add_village(board, village)

    board
    |> add_village(village)
    |> place_villages(n - 1)
  end

  defp find_unoccupied_location(board) do
    location = Location.new(:rand.uniform(@height), :rand.uniform(@width))
    if location_occupied?(board, location) do
      find_unoccupied_location(board)
    else
      location
    end
  end

  defp location_occupied?(board, location) do
    Enum.any?(board.villages, fn {_, village} ->
      village.location == location
    end)
  end

  defp resolve_moves(board) do
    {arrived, ongoing} =
      board.moves
      |> Enum.map(&Move.advance/1)
      |> Enum.split_with(&Move.arrived?/1)

    board_with_moves = %{board | moves: ongoing}

    arrived
    |> Enum.group_by(& &1.to)
    |> Enum.reduce(board_with_moves, &resolve_conflicts/2)
  end

  defp resolve_conflicts({village_name, moves}, board) do
    resolved =
      board.villages
      |> Map.get(village_name)
      |> Village.attack(moves)

    %{board | villages: Map.put(board.villages, village_name, resolved)}
  end

  defp grow_villages(%{villages: villages} = board) do
    grown_villages =
      for {name, village} <- villages, into: %{} do
        {name, Village.grow(village)}
      end

    %{board | villages: grown_villages}
  end

  defp add_village(%{villages: villages} = board, village) do
    name = villages |> Map.size() |> to_string()
    %{board | villages: Map.put(villages, name, village)}
  end

  defp validate_source_village(nil, _), do: :unknown_source_village
  defp validate_source_village(%{owner: x}, player) when player != x, do: :foreign_source_village
  defp validate_source_village(%{units: 0}, _), do: :not_enough_units
  defp validate_source_village(_, _), do: :ok

  defp validate_target_village(nil), do: :unknown_target_village
  defp validate_target_village(_), do: :ok
end
