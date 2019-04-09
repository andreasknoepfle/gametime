defmodule Game do
  defstruct [:name, :players, :state, :actions, :module, :started]

  def new(name) do
    module = find_module(name)
    {:ok, state} = module.init()
    %__MODULE__{
      name: name,
      module: module,
      players: %{},
      actions: %{},
      state: state,
      started: false
    }
  end

  def start(game) do
    %{game | started: true}
  end

  def reset(game) do
    {:ok, state} = game.module.init()
    %{game | state: state}
  end

  def add_player(%{players: players} = game, player) do
    {:ok, state} = game.module.add_player(game.state, player)
    %{game | state: state, players: Map.put(players, player.id, player)}
  end

  def act(%{actions: actions} = game, player_id, player_actions) do
    %{game | actions: Map.put(actions, player_id, player_actions)}
  end

  def advance(game, after: callback) do
    case game.module.advance(game.state, game.actions) do
      {:new_turn, state} ->
        schedule_turn(%{game | state: state}, callback)

      {:finish, state} ->
        %{game | state: state}
    end
  end

  defp schedule_turn(game, callback) do
    Map.put(game, :turn, Turn.start(callback))
    |> notify_players()
    |> clear_actions()
  end

  defp notify_players(game) do
    game.players
    |> Map.values()
    |> Enum.each(fn player -> notify_player(game, player) end)

    game
  end

  def notify_player(game, player) do
    Player.tell(player, game.module.visible_state(game.state))
  end

  defp clear_actions(game) do
    %{game | actions: %{}}
  end

  defp find_module(_name) do
    Game.Example
  end
end
