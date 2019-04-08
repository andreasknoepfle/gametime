defmodule GenGame do
  @type state :: map()
  @type actions :: map()
  @type advance_state :: {:new_turn, state} | {:finish, Strring.t, state}

  @callback init() :: {:ok, state()}
  @callback advance(state(), actions()) :: {advance_state}

  defmacro __using__(_opts) do
    quote do
      @behaviour __MODULE__

      def init do
        {:ok, %{}}
      end
      defoverridable init: 0
    end
  end
end
