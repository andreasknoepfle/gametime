defmodule Civwars.Village do
  @derive Jason.Encoder
  defstruct [:location, :units, :owner]

  @initial_units 10
  @max_units 200

  def new(location) do
    %__MODULE__{
      location: location,
      units: @initial_units,
      owner: nil
    }
  end

  def set_owner(%__MODULE__{} = village, owner), do: %{village | owner: owner}
  def set_units(%__MODULE__{} = village, units), do: %{village | units: units}

  def grow(%__MODULE__{units: 0} = village), do: village
  def grow(%__MODULE__{units: @max_units} = village), do: village
  def grow(%__MODULE__{owner: nil} = village), do: village
  def grow(%__MODULE__{} = village) do
    children =
      village.units
      |> :math.log()
      |> :math.pow(2)
      |> :math.ceil()
      |> trunc()

    %{village | units: village.units + children}
  end

  def attack(%__MODULE__{} = village, incoming_moves) do
    add_units = fn (state, owner, units) ->
      Map.put(state, owner, Map.get(state, owner, 0) + units)
    end

    sorted_moves =
      incoming_moves
      |> Enum.reduce(%{}, fn move, res ->
        add_units.(res, move.owner, move.units)
      end)
      |> add_units.(village.owner, village.units)
      |> Enum.sort_by(fn {_, units} -> units end)
      |> Enum.reverse()

    winner = List.first(sorted_moves) |> elem(0)

    remaining_units =
      case length(sorted_moves) do
        1 ->
          List.first(sorted_moves) |> elem(1)
        _ ->
          [{_, winner_units}, {_, second_units}] = Enum.take(sorted_moves, 2)
          winner_units - second_units
      end

    village
    |> set_owner(winner)
    |> set_units(min(remaining_units, @max_units))
  end

  def recruit_attack_party(%__MODULE__{} = village) do
    units =
      (village.units / 2)
      |> :math.ceil()
      |> trunc()

    {%{village | units: (village.units - units)}, units}
  end
end
