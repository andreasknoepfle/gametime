defmodule GametimeWeb.GameView do
  use GametimeWeb, :view
  import GametimeWeb.GameViewHelpers

  def style_for(style) do
    ~E"""
    <link rel="stylesheet" type="text/css" href="<%= style %>">
    """
  end
end
