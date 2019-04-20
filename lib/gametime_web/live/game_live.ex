defmodule GametimeWeb.GameLive do
  use Phoenix.LiveView
  alias Phoenix.Socket.Broadcast

  def mount(%{cassette: cassette}, socket) do
    updated_socket =
      socket
      |> assign(:state, %{})
      |> assign(:players, GameMaster.players(cassette))
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
end
