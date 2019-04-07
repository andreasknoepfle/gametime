defmodule Player do
  defstruct [:id, :name]

  def id(socket) do
    GametimeWeb.UserSocket.id(socket)
  end

  def new(name, socket) do
    %__MODULE__{id: __MODULE__.id(socket), name: name}
  end
end
