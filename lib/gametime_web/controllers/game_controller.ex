defmodule GametimeWeb.GameController do
  use GametimeWeb, :controller

  import Phoenix.LiveView.Controller

  def show(conn, %{"name" => name}) do
    {:ok, cassette} = Cassette.load(name)
    live_render(conn, GametimeWeb.GameLive, session: %{cassette: cassette})
  end
end
