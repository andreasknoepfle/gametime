defmodule Cassette do
  defstruct [:module, :display_name, :name, :template]

  def load(name) do
    case config_for_name(name) do
      nil -> {:error, "cassette #{name} does not exit"}
      config -> {:ok, cassette_from_config(name, config) }
    end
  end

  def all do
    config_by_name()
    |> Enum.map(fn {name, config} -> cassette_from_config(name, config) end)
  end

  defp config_by_name do
    Application.get_env(:gametime, :cassettes)
  end

  defp config_for_name(name) do
    config_by_name()
    |> Map.get(name)
  end

  defp cassette_from_config(name, config) do
    __MODULE__
    |> struct(config)
    |> struct(name: name)
  end
end
