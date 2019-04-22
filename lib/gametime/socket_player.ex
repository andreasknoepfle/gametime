defmodule SocketPlayer do
  defstruct [:id, :name]

  def new(id, name) do
    %__MODULE__{id: id, name: name}
  end
end

defimpl Player, for: SocketPlayer do
  def tell(player, state) do
    payload = %{
      state: state,
      player_id: player.id
    }

    GametimeWeb.Endpoint.broadcast!("player:" <> player.id, "tell", payload)
  end
end
