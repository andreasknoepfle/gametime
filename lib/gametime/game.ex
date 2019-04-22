defmodule Game do
  defstruct [:name, :players, :state, :actions, :module, :started, :cassette]

  def new(cassette) do
    {:ok, state} = cassette.module.init()
    %__MODULE__{
      cassette: cassette,
      module: cassette.module,
      players: %{},
      actions: %{},
      state: state,
      started: false
    }
  end

  def start(game) do
    %{game | started: true}
    |> update_live_views("started")
  end

  def reset(game) do
    {:ok, state} = game.module.init()
    %{game | state: state}
    |> respawn_all_players
    |> update_live_views("state")
  end

  def add_player(%{players: players} = game, player) do
    %{game | players: Map.put(players, player.id, player)}
    |> spawn_player(player.id)
    |> update_live_views("players")
    |> update_live_views("state")
  end

  def remove_player(%{players: players} = game, player_id) do
    state = game.module.remove_player(game.state, player_id)
    %{game | state: state, players: Map.delete(players, player_id)}
    |> update_live_views("players")
    |> update_live_views("state")
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
    |> update_live_views("state")
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
    Player.tell(player, game.module.visible_state(player.id, game.state))
  end

  defp clear_actions(game) do
    %{game | actions: %{}}
  end

  defp update_live_views(game = %{state: state}, event = "state") do
    update_live_views(game, event, state)
  end
  defp update_live_views(game = %{players: players}, event = "players") do
    update_live_views(game, event, players)
  end
  defp update_live_views(game = %{started: started}, event = "started") do
    update_live_views(game, event, %{started: started})
  end
  defp update_live_views(game = %{cassette: cassette}, event, payload) do
    GametimeWeb.Endpoint.broadcast("game:state:" <> cassette.name, event, payload)
    game
  end

  defp spawn_player(game = %{state: state}, player_id) do
    {:ok, new_state} = game.module.add_player(state, player_id)
    %{game | state: new_state}
  end

  defp respawn_all_players(game = %{players: players}) do
    Map.keys(players)
    |> Enum.reduce(game, fn (id, game) -> spawn_player(game, id) end)
  end
end
