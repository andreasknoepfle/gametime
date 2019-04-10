defmodule Civwars do
  use GenGame
  alias Civwars.Board

  @impl true
  def init do
    {:ok, Board.new()}
  end

  @impl true
  def add_player(%Board{} = board, player) do
    {:ok, Board.spawn(board, player)}
  end

  @impl true
  def advance(%Board{} = board, actions) do
    new_board =
      actions
      |> Enum.reduce(board, fn action, board ->
        {_result, board_with_move} =
          Board.move(board, action.player, action.from, action.to)

        board_with_move
      end)
      |> Board.advance()

    {:new_turn, new_board}
  end
end
