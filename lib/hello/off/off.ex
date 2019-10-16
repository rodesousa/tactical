defmodule HelloWeb.Off do
  defstruct [
    :stamina,
    :atk,
    :vit,
    :defense
  ]

  def start do
  end

  def alive?(a), do: a.stamina <= 0

  def atk(atk), do: atk
  def defense(defense), do: defense
  def counter(atk, defense), do: atk / 2 + defense / 2
  def dodge(vit, defense), do: vit / 2 + defense / 2
  def overhead(atk), do: atk * 1.25
  def feint(vit, atk), do: vit / 2 + atk / 2

  # liste des coups qu'un défenseur peut faire
  def patern(:patern_def) do
  end

  # liste des coups qu'un offensive peut faire
  def patern_off(:patern_off) do
  end

  def stamina(:atk), do: 1
  def stamina(:defense), do: 1
  def stamina(:counter), do:
  def stamina(:dodge), do:
  def stamina(:overhead), do:
  def stamina(:feint), do:
end
