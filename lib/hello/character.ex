defmodule HelloWeb.Character do
  alias __MODULE__
  defstruct [:color, :name, stamina: 15]

  def warrior(name, color), do: %Character{name: name, color: color}

  def get_color!(character) do
    if character, do: character.color, else: nil
  end
end
