defmodule Game do
  defstruct [:players, :state, :actions]

  def new() do
    %__MODULE__{players: %{}, actions: %{}, state: Game.init()}
  end

  def init() do
    %{}
  end

  def reset(game) do
    %{ game | state: Game.init() }
  end

  def add_player(%{players: players} = game, player) do
    %{ game | players: Map.put(players, player.id, player) }
  end

  def act(%{actions: actions} = game, player_id, player_actions) do
    %{ game | actions: Map.put(actions, player_id, player_actions) }
  end

  def advance(game) do
    game
  end
end
