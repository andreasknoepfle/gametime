defmodule GenGame do
  @type state :: map()
  @type actions :: map()
  @type advance_state :: {:new_turn, state} | {:finish, state}

  @callback init() :: {:ok, state()}
  @callback advance(state(), actions()) :: {advance_state}
  @callback add_player(state(), any()) :: {:ok, state()} | {:error, String.t}
  @callback remove_player(state(), any()) :: state()
  @callback visible_state(any(), state()) :: state()

  defmacro __using__(_opts) do
    quote do
      @behaviour GenGame

      def init, do: {:ok, %{}}
      defoverridable init: 0

      def add_player(state, _player), do: {:ok, state}
      defoverridable add_player: 2

      def remove_player(state, _player), do: state
      defoverridable remove_player: 2

      def visible_state(_, state), do: state
      defoverridable visible_state: 2
    end
  end
end
