defmodule SocketPlayer do
  defstruct [:id, :name, :socket]

  def id(socket) do
    GametimeWeb.PlayerSocket.id(socket)
  end

  def new(name, socket) do
    %__MODULE__{id: id(socket), name: name, socket: socket}
  end
end

defimpl Player, for: SocketPlayer do
  def tell(player, state) do
    # GametimeWeb.Endpoint.broadcast(player.id, "tell", state)
    GametimeWeb.GameChannel.tell(player.socket, state)
  end
end
