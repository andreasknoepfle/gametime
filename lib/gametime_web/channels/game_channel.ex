defmodule GametimeWeb.GameChannel do
  use GametimeWeb, :channel

  def join("game", %{"name" => name}, socket) do
    GameMaster.join(Player.new(name, socket))
    {:ok, socket}
  end

  def handle_in("act", %{"actions" => actions}, socket) do
    Player.id(socket)
    |> GameMaster.act(actions)
    {:reply, {:thanks, %{}}, socket}
  end
end
