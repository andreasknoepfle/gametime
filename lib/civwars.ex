defmodule Civwars do
  alias Civwars.Board

  def init do
    %{
      board: Board.new(),
      players: []
    }
  end

  def add_player(state, player) do
    new_players = [player | state.players]
    new_board = Board.add_player(state.board, player)

    %{state | players: new_players, board: new_board}
  end

  def advance(state, actions) do
    update_in(state[:board], fn board ->
      board
      |> Board.apply_actions(actions)
      |> Board.advance()
    end)
  end
end
