defmodule HelloWeb.State do
  alias HelloWeb.Character

  defstruct [
    :show_character,
    positions: Enum.map(1..81, fn _ -> nil end),
    edit_case_color: "blue",
    mode: "edition"
  ]

  def cell!(index, positions), do: Enum.at(positions, index)

  def click(index, %{positions: pos, edit_case_color: color} = state) do
    case state.mode do
      "edition" ->
        if character = cell!(index, pos) do
          %{state | show_character: character}
        else
          new_pos = List.replace_at(pos, index, Character.warrior("Warrior", color))
          # new_pos = List.replace_at(pos, index, color)
          %{state | positions: new_pos}
        end

      _ ->
        state
    end
  end

  def changed_edit_case_color(%{edit_case_color: "blue"} = state),
    do: %{state | edit_case_color: "red"}

  def changed_edit_case_color(%{edit_case_color: "red"} = state),
    do: %{state | edit_case_color: "blue"}

  def enter(state) do
    filter =
      state.positions
      |> Enum.with_index()
      |> Enum.filter(fn {x, _} -> x != nil end)
      |> rec(state.positions)

    %{state | positions: filter}
    # state
  end

  def rec([], response), do: response

  def rec([{color, index} | tail], response) do
    step = if color == "blue", do: 9, else: -9

    if progress?(index, response, step) do
      new_response =
        response
        |> List.replace_at(index, nil)
        |> List.replace_at(index + step, color)

      if Enum.at(new_response, index + step) do
        HelloWeb.Fight.fight()
      end

      rec(tail, new_response)
    else
      rec(tail, response)
    end
  end

  def progress?(index, state, step) do
    cond do
      index + step > 81 || index + step < 0 ->
        false

      Enum.at(state, index + step) ->
        false

      true ->
        true
    end
  end

  def progress_red?(index, state) do
    cond do
      Map.has_key?(state, index - 9) -> false
      Map.get(state, index - 9) == {index + 9, nil} -> false
      true -> true
    end
  end
end
