defmodule GameMaster do
  use GenServer

  def start_link(game_module) do
    GenServer.start_link(__MODULE__, game_module, name: game_module)
  end

  def join(game_module, player) do
    GenServer.call(game_module, {:join, player})
  end

  def start_round(game_module) do
    GenServer.cast(game_module, :start_round)
  end

  def act(game_module, player_id, actions) do
    GenServer.call(game_module, {:act, player_id, actions})
  end

  @impl true
  def init(game_module) do
    {:ok, Game.new(game_module)}
  end

  @impl true
  def handle_call({:join, player}, from, %{started: false} = game) do
    start_round(game.module)
    handle_call({:join, player}, from, Game.start(game))
  end
  def handle_call({:join, player}, _, game) do
    {:reply, :ok, Game.add_player(game, player)}
  end

  def handle_call({:act, player_id, actions}, _, game) do
    {:reply, :ok, Game.act(game, player_id, actions)}
  end

  @impl true
  def handle_cast(:start_round, game) do
    {:noreply, Game.advance(game, after: fn -> start_round(game.module) end)}
  end
end
