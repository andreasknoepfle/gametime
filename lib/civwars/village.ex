defmodule Civwars.Village do
  defstruct [:population, :owner]

  @initial_population 10

  def new(population \\ @initial_population, owner \\ nil) do
    %__MODULE__{
      population: population,
      owner: owner
    }
  end

  def grow(%__MODULE__{population: 0} = village), do: village
  def grow(%__MODULE__{} = village) do
    children =
      village.population
      |> :math.log()
      |> :math.pow(2)
      |> :math.ceil()
      |> trunc()

    %{village | population: village.population + children}
  end

  def attack(%__MODULE__{population: p}, _, s) when p == s do
    new(0)
  end
  def attack(%__MODULE__{population: p} = village, _, s) when p > s do
    %{village | population: p - s}
  end
  def attack(%__MODULE__{population: p}, attacker, s) when p < s do
    new(s - p, attacker)
  end
end
