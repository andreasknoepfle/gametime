defmodule GameMaster do
  use GenServer

  def child_spec(cassette) do
    %{
      id: cassette.module,
      start: {GameMaster, :start_link, [cassette]}
    }
  end

  def start_link(cassette) do
    GenServer.start_link(__MODULE__, cassette, name: cassette.module)
  end

  def join(cassette, player) do
    GenServer.call(cassette.module, {:join, player})
  end

  def start_round(cassette) do
    GenServer.cast(cassette.module, :start_round)
  end

  def act(cassette, player_id, actions) do
    GenServer.call(cassette.module, {:act, player_id, actions})
  end

  def players(cassette) do
    GenServer.call(cassette.module, :players)
  end

  @impl true
  def init(cassette) do
    {:ok, Game.new(cassette)}
  end

  @impl true
  def handle_call({:join, player}, from, %{started: false} = game) do
    start_round(game.cassette)
    handle_call({:join, player}, from, Game.start(game))
  end
  def handle_call({:join, player}, _, game) do
    {:reply, :ok, Game.add_player(game, player)}
  end

  def handle_call({:act, player_id, actions}, _, game) do
    {:reply, :ok, Game.act(game, player_id, actions)}
  end
  def handle_call(:players, _, game) do
    {:reply, game.players, game}
  end

  @impl true
  def handle_cast(:start_round, game) do
    {:noreply, Game.advance(game, after: fn -> start_round(game.cassette) end)}
  end
end
