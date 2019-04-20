defmodule GametimeWeb.PageView do
  use GametimeWeb, :view

  def cassettes do
    Cassette.all
  end
end
