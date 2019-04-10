defmodule Civwars do
  use GenGame
  alias Civwars.Board

  defmodule State do
    @derive Jason.Encoder
    defstruct [:board, :players]

    def new do
      %{
        board: Board.new(),
        players: []
      }
    end
  end

  @impl true
  def init do
    {:ok, State.new()}
  end

  @impl true
  def add_player(%State{} = state, player) do
    if Enum.member?(state.players, player) do
      {:error, "already joined"}
    else
      new_players = [player | state.players]
      new_board = Board.add_player(state.board, player)

      new_state =
        %{state | players: new_players, board: new_board}

      {:ok, new_state}
    end
  end

  @impl true
  def advance(%State{} = state, actions) do
    new_state =
      update_in(state[:board], fn board ->
        board
        |> Board.apply_actions(actions)
        |> Board.advance()
      end)

    {:new_turn, new_state}
  end
end
