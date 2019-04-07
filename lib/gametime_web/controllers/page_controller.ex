defmodule GametimeWeb.PageController do
  use GametimeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
