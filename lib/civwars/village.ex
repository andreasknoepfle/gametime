defmodule Civwars.Village do
  defstruct [:population, :owner]

  @initial_population 10
  @max_population 200

  def new do
    %__MODULE__{
      population: @initial_population,
      owner: nil
    }
  end

  def set_owner(%__MODULE__{} = village, owner), do: %{village | owner: owner}
  def set_population(%__MODULE__{} = village, population), do: %{village | population: population}

  def grow(%__MODULE__{population: 0} = village), do: village
  def grow(%__MODULE__{population: @max_population} = village), do: village
  def grow(%__MODULE__{owner: nil} = village), do: village
  def grow(%__MODULE__{} = village) do
    children =
      village.population
      |> :math.log()
      |> :math.pow(2)
      |> :math.ceil()
      |> trunc()

    %{village | population: village.population + children}
  end

  def attack(%__MODULE__{} = village, incoming_moves) do
    # TODO: implement
    village
  end
end
