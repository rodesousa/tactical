defmodule Friends.Person do
  use Ecto.Schema

  schema "people" do
    field(:name, :string)
    field(:patern, :string)
    field(:stamina, :integer)
    field(:atk, :integer)
    field(:vit, :integer)
    field(:def, :integer)
    field(:moves, :map)
    field(:buffs, :map)
  end
end
