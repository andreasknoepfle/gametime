defmodule GameMaster do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def join(player) do
    GenServer.call(__MODULE__, {:join, player})
  end

  def tick do
    GenServer.cast(__MODULE__, :tick)
  end

  def act(player_id, actions) do
    GenServer.call(__MODULE__, {:act, player_id, actions})
  end

  @impl true
  def init(_) do
    {:ok, Game.new()}
  end

  @impl true
  def handle_call({:join, player}, _, game) do
    {:reply, :ok, Game.add_player(game, player)}
  end
  def handle_call(:state, _, game) do
    {:reply, game, game}
  end
  def handle_call({:act, player_id, actions}, _, game) do
    {:reply, :ok, Game.act(game, player_id, actions) }
  end

  @impl true
  def handle_cast(:tick, game) do
    {:noreply, Game.advance(game, after: &tick/0)}
  end
end
