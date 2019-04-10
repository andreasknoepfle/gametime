defmodule Civwars do
  use GenGame
  alias Civwars.Board

  def simulate do
    init()
    |> elem(1)
    |> add_player("Andi")
    |> simulate_turns(5)
    |> advance([%{player: "Andi", from: "4", to: "0"}])
    |> simulate_turns(10)
  end

  def simulate_turns({_, board}, 0), do: board
  def simulate_turns({_, board}, n) do
    IO.puts("======= TURN =======")

    board
    |> IO.inspect()
    |> advance([])
    |> simulate_turns(n - 1)
  end

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
