defmodule HelloWeb.State do
  defstruct positions: Enum.map(1..81, fn _ -> nil end),
            edit_case_color: "blue"

  def click(index, %{positions: pos, edit_case_color: color} = state) do
    new_pos = List.replace_at(pos, index, color)
    %{state | positions: new_pos}
  end

  def changed_edit_case_color(%{edit_case_color: "blue"} = state),
    do: %{state | edit_case_color: "red"}

  def changed_edit_case_color(%{edit_case_color: "red"} = state),
    do: %{state | edit_case_color: "blue"}

  def enter(state) do
    filter =
      state.positions
      |> Enum.with_index()
      |> Enum.filter(fn {x, _} -> x == "blue" end)
      |> rec(state.positions)

    %{state | positions: filter}
    # state
  end

  def rec([], response), do: response

  def rec([{color, index} | tail], response) do
    if progress_blue?(index, response) do
      new_response =
        response
        |> List.replace_at(index, nil)
        |> List.replace_at(index + 9, color)

      rec(tail, new_response)
    else
      rec(tail, response)
    end
  end

  def progress_blue?(index, state) do
    cond do
      index + 9 > 81 ->
        false

      Enum.at(state, index + 9) ->
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
