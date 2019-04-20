defmodule GametimeWeb.Router do
  use GametimeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GametimeWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/games/:name", GameController, :show
    get "/players/:game_name/:name", PlayerController, :start
  end

  # Other scopes may use custom stacks.
  # scope "/api", GametimeWeb do
  #   pipe_through :api
  # end
end
