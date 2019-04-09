defmodule GameMaster do
  use GenServer

  def start_link(game_name) do
    GenServer.start_link(__MODULE__, game_name, name: game_name)
  end

  def join(game_name, player) do
    GenServer.call(game_name, {:join, player})
  end

  def tick(game_name) do
    GenServer.cast(game_name, :tick)
  end

  def act(game_name, player_id, actions) do
    GenServer.call(game_name, {:act, player_id, actions})
  end

  @impl true
  def init(game_name) do
    {:ok, Game.new(game_name)}
  end

  @impl true
  def handle_call({:join, player}, _, game) do
    {:reply, :ok, Game.add_player(game, player)}
  end

  def handle_call({:act, player_id, actions}, _, game) do
    {:reply, :ok, Game.act(game, player_id, actions)}
  end

  @impl true
  def handle_cast(:tick, game) do
    {:noreply, Game.advance(game, after: fn -> tick(game.name) end)}
  end
end
