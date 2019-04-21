defmodule GametimeWeb.GameLive do
  use Phoenix.LiveView
  alias Phoenix.Socket.Broadcast

  def mount(%{cassette: cassette}, socket) do
    game = GameMaster.game(cassette)
    updated_socket =
      socket
      |> assign(:state, game.state)
      |> assign(:players, game.players)
      |> assign(:started, game.started)
      |> assign(:cassette, cassette)
    :ok = GametimeWeb.Endpoint.subscribe("game:state:" <> cassette.name)
    {:ok, updated_socket}
  end

  def render(assigns) do
    GametimeWeb.GameView.render("default.html", assigns)
  end

  def handle_info(%Broadcast{topic: _, event: "state", payload: payload}, socket) do
    {:noreply, update(socket, :state, fn (_) -> payload end)}
  end
  def handle_info(%Broadcast{topic: _, event: "players", payload: payload}, socket) do
    {:noreply, update(socket, :players, fn (_) -> payload end)}
  end
  def handle_info(%Broadcast{topic: _, event: "started"}, socket) do
    {:noreply, update(socket, :started, fn (_) -> true end)}
  end

  def handle_event("start", _value, socket) do
    if(!socket.assigns.started) do
      GameMaster.start(socket.assigns.cassette)
    end
    {:noreply, socket}
  end
  def handle_event("reset", _value, socket) do
    GameMaster.reset(socket.assigns.cassette)
    {:noreply, socket}
  end
  def handle_event("kick", player_id, socket) do
    GameMaster.kick(socket.assigns.cassette, player_id)
    {:noreply, socket}
  end
end
