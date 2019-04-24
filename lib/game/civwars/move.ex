defmodule Civwars.Move do
  alias Civwars.Location

  @derive Jason.Encoder
  defstruct [:to, :destination, :source, :location, :units, :owner, :duration, :id]

  @speed 5

  def new(to, destination, source, units, owner) do
    distance = Location.distance(source, destination)
    %__MODULE__{
      to: to,
      destination: destination,
      source: source,
      location: source,
      units: units,
      owner: owner,
      duration: duration(distance),
      id: SecureRandom.uuid()
    }
  end

  def advance(%__MODULE__{} = move) do
    new_location = Location.move_towards(move.location, move.destination, @speed)
    %{move | location: new_location}
  end

  def arrived?(%__MODULE__{destination: x, location: x}), do: true
  def arrived?(%__MODULE__{}), do: false

  defp duration(distance) do
    ((:math.ceil(distance/@speed)) * 500)
    |> Float.to_string(decimals: 4)
  end
end
