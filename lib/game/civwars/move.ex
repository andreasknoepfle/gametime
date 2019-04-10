defmodule Civwars.Move do
  @derive Jason.Encoder
  defstruct [:to, :distance, :units, :owner]

  @speed 5

  def new(to, distance, units, owner) do
    %__MODULE__{
      to: to,
      distance: distance,
      units: units,
      owner: owner
    }
  end

  def advance(%__MODULE__{distance: distance} = move) do
    %{move | distance: max(distance - @speed, 0)}
  end

  def arrived?(%__MODULE__{distance: 0}), do: true
  def arrived?(%__MODULE__{}), do: false
end
