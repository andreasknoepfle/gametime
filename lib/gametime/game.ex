defmodule Game do
  defstruct [:players, :state, :actions]

  def new() do
    %__MODULE__{players: %{}, actions: %{}, state: Game.init()}
  end

  def init() do
    %{}
  end

  def reset(game) do
    %{game | state: Game.init()}
  end

  def add_player(%{players: players} = game, player) do
    %{game | players: Map.put(players, player.id, player)}
  end

  def act(%{actions: actions} = game, player_id, player_actions) do
    %{game | actions: Map.put(actions, player_id, player_actions)}
  end

  def advance(game, after: callback) do
    game
    |> schedule_turn(callback)
    |> notify_players
    |> clear_actions
  end

  defp schedule_turn(game, callback) do
    Map.put(game, :turn, Turn.start(callback))
  end

  defp notify_players(game) do
    game.players
    |> Map.values
    |> Enum.each(fn player -> Player.tell(player, game.state) end)
    game
  end

  defp clear_actions(game) do
    %{game | actions: %{}}
  end
end
