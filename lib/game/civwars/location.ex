defmodule Civwars.Location do
  @derive Jason.Encoder
  defstruct [:x, :y]

  def new(x, y) do
    %__MODULE__{
      x: x,
      y: y
    }
  end

  def distance(%__MODULE__{} = a, %__MODULE__{} = b) do
    cx =
      (a.x - b.x)
      |> abs()
      |> :math.pow(2)

    cy =
      (a.x - b.x)
      |> abs()
      |> :math.pow(2)

    (cx + cy)
    |> :math.sqrt()
    |> :math.ceil()
    |> trunc()
  end
end
