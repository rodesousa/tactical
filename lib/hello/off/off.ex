defmodule HelloWeb.Off do
  defstruct [
    :name,
    :stamina,
    :atk,
    :vit,
    :defense,
    # a map that know if we can do a hit
    # example: moves: %{overhead: false} -> u don't use overhead
    :moves,
    # a map that increase/downcrease some stats and hits
    # example: buffs: %{atk: 5, overhead: -2}
    :buffs,
    # his behavior, it's not well
    :patern
  ]

  @patern_def :patern_def
  @patern_off :patern_off

  def start do
    perso_a = %__MODULE__{
      name: "A",
      stamina: 10,
      atk: 3,
      vit: 5,
      defense: 3,
      patern: @patern_off
    }

    perso_b = %__MODULE__{
      name: "B",
      stamina: 10,
      atk: 4,
      vit: 5,
      defense: 2,
      patern: @patern_def
    }

    # For now it's A who begin
    fight(perso_a, perso_b)
  end

  def buff(stat, buff) when stat >= 0, do: stat + buff
  def buff(stat, buff) when stat < 0, do: stat - buff

  def fight(perso_a, perso_b) do
    if alive?(perso_a) && alive?(perso_b) do
      with burst_a <- Enum.random(0..3),
           burst_b <- Enum.random(0..3) do
        {hit_a, perso_a} = patern(perso_a)
        {hit_b, perso_b} = patern(perso_b, perso_a, hit_a)

        result_hit_a = buff(hit(hit_a, perso_a), burst_a)
        result_hit_b = buff(hit(hit_b, perso_b), burst_b)

        # prehit
        prehit(perso_a, hit_a, perso_b, hit_b)

        IO.inspect("A fait #{hit_a} avec #{result_hit_a} et B fait #{hit_b} avec #{result_hit_b}")

        {perso_a, perso_b} =
          cond do
            offensive?(hit_a) && !offensive?(hit_b) ->
              score = result_hit_a + result_hit_b
              IO.inspect(score)

              if score > 0 do
                perso_b = downcrease_stats(hit_a, perso_b)
                perso_a = increase_stats(hit_a, perso_a)
                {perso_a, %{perso_b | stamina: perso_b.stamina - score}}
              else
                perso_a = downcrease_stats(hit_b, perso_b)
                perso_b = increase_stats(hit_b, perso_b)
                {perso_a, perso_b}
              end

            offensive?(hit_b) && !offensive?(hit_a) ->
              score = result_hit_b + result_hit_a
              IO.inspect(score)

              if score > 0 do
                perso_a = downcrease_stats(hit_b, perso_a)
                perso_b = increase_stats(hit_b, perso_b)
                {%{perso_a | stamina: perso_a.stamina - score}, perso_b}
              else
                perso_b = downcrease_stats(hit_a, perso_b)
                perso_a = increase_stats(hit_a, perso_a)
                {perso_a, perso_b}
              end

            offensive?(hit_a) && offensive?(hit_b) ->
              score = result_hit_a - result_hit_b
              IO.inspect(score)

              cond do
                score > 0 ->
                  perso_a = downcrease_stats(hit_b, perso_a)
                  perso_b = increase_stats(hit_b, perso_b)
                  {%{perso_a | stamina: perso_a.stamina - score}, perso_b}

                score < 0 ->
                  perso_b = downcrease_stats(hit_a, perso_b)
                  perso_a = increase_stats(hit_a, perso_a)
                  {perso_a, %{perso_b | stamina: perso_b.stamina - score}}

                true ->
                  {perso_a, perso_b}
              end

            true ->
              {perso_a, perso_b}
          end

        IO.inspect("A stamina: #{perso_a.stamina}, B stamina: #{perso_b.stamina}")
        fight(perso_a, perso_b)
      end
    else
      IO.inspect("DONE")
      IO.inspect("A: #{perso_a.stamina}, B: #{perso_b.stamina}")
    end
  end

  def offensive?(hit) when hit in [:atk, :overhead, :feint], do: true
  def offensive?(_), do: false

  def alive?(a), do: a.stamina > 0

  def prehit(perso_a, hit_a, perso_b, hit_b) do
  end

  def hit(nil, me), do: hit(:defense, me)
  def hit(:atk, %{atk: atk} = me), do: atk
  def hit(:defense, %{defense: defense} = me), do: defense * -1
  def hit(:counter, %{atk: atk, defense: defense} = me), do: -(atk / 2 + defense / 2)
  def hit(:dodge, %{vit: vit, defense: defense} = me), do: -(vit / 2 + defense / 2)
  def hit(:overhead, %{atk: atk} = me), do: atk * 1.25
  def hit(:feint, %{vit: vit, atk: atk} = me), do: vit / 2 + atk / 2

  # hit list that a "defensor" can do
  # the boost must be here
  def patern(%{patern: @patern_def} = me, opp, hit_opp) do
    with decision <- Enum.random(1..100) do
      decision_tree = %{
        atk: %{defense: 50, counter: 85, dodge: 100},
        overhead: %{defense: 45, counter: 55, dodge: 100},
        feint: %{atk: 30, dodge: 70, defense: 100},
        defense: %{atk: 80, feint: 100},
        dodge: %{feint: 70, dodge: 100},
        counter: %{feint: 70, dodge: 100},
        nada: %{atk: 20, defense: 100}
      }

      own_decision =
        Map.fetch!(decision_tree, hit_opp)
        |> Enum.reduce_while(0, fn {key, value}, acc ->
          if decision <= value, do: {:halt, key}, else: {:cont, acc}
        end)

      {own_decision, me}
    end
  end

  # hit list that a "atackor" can do
  def patern(%{patern: @patern_off} = me, opp \\ nil, hit_opp \\ :nada) do
    with decision <- Enum.random(1..100) do
      decision_tree = %{
        atk: %{atk: 50, defense: 70, dodge: 100},
        overhead: %{defense: 25, counter: 55, dodge: 100},
        feint: %{atk: 10, dodge: 80, defense: 100},
        defense: %{atk: 80, feint: 100},
        dodge: %{feint: 70, dodge: 100},
        counter: %{feint: 70, dodge: 100},
        nada: %{atk: 60, overhead: 80, feint: 100}
      }

      own_decision =
        Map.fetch!(decision_tree, hit_opp)
        |> Enum.reduce_while(0, fn {key, value}, acc ->
          if decision <= value, do: {:halt, key}, else: {:cont, acc}
        end)

      {own_decision, me}
    end
  end

  #######
  #######
  #######

  def downcrease_stats(:atk, me) do
    me
    |> Map.put(:buffs, %{defense: 1})
    |> Map.put(:moves, %{feint: false, overhead: false})

    # a la place de false on peut mettre un statut, comme ca on peut savoir si il a pas le droit ou si c'est stamina * 2 ou autre chose
  end

  def downcrease_stats(:feint, me) do
    me
    |> Map.put(:buffs, %{defense: 1})
    |> Map.put(:moves, %{feint: false, overhead: false, dodge: false})

    # a la place de false on peut mettre un statut, comme ca on peut savoir si il a pas le droit ou si c'est stamina * 2 ou autre chose
  end

  def downcrease_stats(:defense, me), do: me
  def downcrease_stats(:dodge, me), do: me
  def downcrease_stats(:counter, me), do: me

  def downcrease_stats(:overhead, me) do
    me
    |> Map.put(:buffs, %{defense: -1, vit: -1})
    |> Map.put(:moves, %{counter: false})

    # a la place de false on peut mettre un statut, comme ca on peut savoir si il a pas le droit ou si c'est stamina * 2 ou autre chose
  end

  #######
  #######
  #######

  def increase_stats(:dodge, me), do: me
  def increase_stats(:counter, me), do: me
  def increase_stats(:defense, me), do: me
  # post
  def increase_stats(:overhead, me) do
    me
    |> Map.put(:buffs, %{vit: 2, atk: 1})
    |> Map.put(:moves, %{overhead: false, counter: false})
  end

  # post
  def increase_stats(:atk, me) do
    me
    |> Map.put(:buffs, %{vit: 1, atk: 1, overhead: 1})
    |> Map.put(:moves, %{dodge: false, counter: false})
  end

  # post
  def increase_stats(:feint, me) do
    me
    |> Map.put(:buffs, %{vit: 2, atk: 2})
    |> Map.put(:moves, %{
      dodge: false,
      overhead: false,
      defense: false
    })
  end

  #######
  #######
  #######

  def stamina(:atk), do: 1
  def stamina(:defense), do: 1
  def stamina(:counter), do: 3
  def stamina(:dodge), do: 2
  def stamina(:overhead), do: 4
  def stamina(:feint), do: 2
end
