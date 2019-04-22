defmodule Civwars.Move do
  alias Civwars.Location

  @derive Jason.Encoder
  defstruct [:to, :destination, :location, :units, :owner]

  @speed 5

  def new(to, destination, location, units, owner) do
    %__MODULE__{
      to: to,
      destination: destination,
      location: location,
      units: units,
      owner: owner
    }
  end

  def advance(%__MODULE__{} = move) do
    new_location = Location.move_towards(move.location, move.destination, @speed)
    %{move | location: new_location}
  end

  def arrived?(%__MODULE__{destination: x, location: x}), do: true
  def arrived?(%__MODULE__{}), do: false
end
