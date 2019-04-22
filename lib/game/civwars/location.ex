defmodule Civwars.Location do
  @derive Jason.Encoder
  defstruct [:x, :y]

  def new(x, y) do
    %__MODULE__{
      x: x,
      y: y
    }
  end

  def move_towards(%__MODULE__{} = a, %__MODULE__{} = b, speed) do
    d = distance(a, b)

    if speed >= d do
      b
    else
      dx =
        (b.x - a.x) * (speed / d)
        |> :math.floor()
        |> trunc()

      dy =
        (b.y - a.y) * (speed / d)
        |> :math.floor()
        |> trunc()

      %{a | x: a.x + dx, y: a.y + dy}
    end
  end

  defp distance(a, b) do
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
