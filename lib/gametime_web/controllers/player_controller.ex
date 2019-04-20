defmodule GametimeWeb.PlayerController do
  use GametimeWeb, :controller

  plug :put_layout, false

  def start(conn, %{"game_name" => game_name, "name" => name}) do
    render(conn, "start.html", %{game_name: game_name, name: name})
  end
end
