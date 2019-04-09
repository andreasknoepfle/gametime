defmodule GametimeWeb.GameChannel do
  use GametimeWeb, :channel

  def join("game:" <> game_name, %{"name" => name}, %{assigns: %{id: player_id}} = socket) do
    :ok = GametimeWeb.Endpoint.subscribe("player:" <> player_id)
    GameMaster.join(String.to_existing_atom(game_name), SocketPlayer.new(player_id, name))
    {:ok, socket}
  end

  def handle_in(
        "act",
        %{"actions" => actions},
        %{topic: "game" <> name, assigns: %{id: player_id}} = socket
      ) do
    GameMaster.act(name, player_id, actions)

    {:reply, {:thanks, %{}}, socket}
  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
