defmodule Game.Example do
  use GenGame

  def init do
    {:ok, %{turn: 0, actions: []}}
  end

  def advance(%{turn: turn, actions: actions} = state, new_actions) do
    new_state =
      state
      |> Map.put(:turn, turn + 1)
      |> Map.put(:actions, actions ++ [new_actions])
    {:new_turn, new_state}
  end
end
