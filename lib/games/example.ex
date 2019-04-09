defmodule Game.Example do
  use GenGame

  def init do
    {:ok, %{turn: 0}}
  end

  def advance(%{turn: turn} = state, actions) do
    new_state =
      state
      |> Map.put(:turn, turn + 1)
      |> Map.put(turn, actions)
    {:new_turn, new_state}
  end
end
