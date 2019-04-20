defmodule GametimeWeb.GameChannel do
  use GametimeWeb, :channel

  def join("game:" <> game_name, %{"name" => name}, %{assigns: %{id: player_id}} = socket) do
    :ok = GametimeWeb.Endpoint.subscribe("player:" <> player_id)

    with {:ok, cassette} <- Cassette.load(game_name),
         :ok <- GameMaster.join(cassette, SocketPlayer.new(player_id, name)),
         do: {:ok, socket}
  end

  def handle_in(
        "act",
        %{"actions" => actions},
        %{topic: "game:" <> game_name, assigns: %{id: player_id}} = socket
      ) do
    with {:ok, cassette} <- Cassette.load(game_name),
         :ok <- GameMaster.act(cassette, player_id, actions),
         do: {:reply, {:thanks, %{}}, socket}
  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
