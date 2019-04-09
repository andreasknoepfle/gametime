defmodule Civwars.Move do
  alias Civwars.Location

  defstruct [:to, :distance, :units, :owner]

  @speed 5

  def new(%Location{} = from, %Location{} = to, units, owner) do
    %__MODULE__{
      to: to,
      distance: Location.distance(from, to),
      units: units,
      owner: owner
    }
  end

  def advance(%__MODULE__{distance: distance} = move) do
    %{move | distance: min(distance - @speed, 0)}
  end

  def arrived?(%__MODULE__{distance: 0}), do: true
  def arrived?(%__MODULE__{}), do: false
end
