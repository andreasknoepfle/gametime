defmodule GametimeWeb.GameViewHelpers do
  def hex_color_from_uuid(nil), do: "#888888"
  def hex_color_from_uuid(uuid) do
    color =
      uuid
      |> :erlang.crc32()
      |> Integer.to_string(16)
      |> String.slice(0..5)

    "##{color}"
  end
end
