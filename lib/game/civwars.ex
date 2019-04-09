defmodule Civwars do
  use GenGame
  alias Civwars.Board

  @impl true
  def init do
    state =
      %{
        board: Board.new(),
        players: []
      }

    {:ok, state}
  end

  @impl true
  def add_player(state, player) do
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
  def advance(state, actions) do
    new_state =
      update_in(state[:board], fn board ->
        board
        |> Board.apply_actions(actions)
        |> Board.advance()
      end)

    {:new_turn, new_state}
  end

  def visible_state(_, state) do
    IO.inspect(state)
    %{}
  end
end
