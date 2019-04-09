defmodule Civwars do
  alias Civwars.Board

  def init do
    %{
      board: Board.new(),
      players: []
    }
  end

  def add_player(state, player) do
    %{state | players: [player | state.players] }
  end

  def advance(state, actions) do
    update_in(state[:board], fn board ->
      board
      |> Board.apply_actions(actions)
      |> Board.advance()
    end)
  end
end
