defmodule GametimeWeb.GameChannel do
  use GametimeWeb, :channel

  def join("game", %{"name" => name}, socket) do
    send(self, {:add_player, name})
    {:ok, socket}
  end

  def tell(socket, state) do
    push(socket, "tell", state)
  end

  def handle_info({:add_player, name}, socket) do
    GameMaster.join(SocketPlayer.new(name, socket))
    {:noreply, socket}
  end

  def handle_in("act", %{"actions" => actions}, socket) do
    SocketPlayer.id(socket)
    |> GameMaster.act(actions)
    {:reply, {:thanks, %{}}, socket}
  end
end
