defmodule GametimeWeb.GameChannel do
  use GametimeWeb, :channel

  def join("game:" <> game_name, %{"name" => name}, %{assigns: %{id: player_id}} = socket) do
    :ok = GametimeWeb.Endpoint.subscribe("player:" <> player_id)

    String.to_existing_atom(game_name)
    |> GameMaster.join(SocketPlayer.new(player_id, name))

    {:ok, socket}
  end

  def handle_in(
        "act",
        %{"actions" => actions},
        %{topic: "game:" <> game_name, assigns: %{id: player_id}} = socket
      ) do
    String.to_existing_atom(game_name)
    |> GameMaster.act(player_id, actions)

    {:reply, {:thanks, %{}}, socket}
  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
