defmodule HelloWeb.State do
  defstruct positions: Enum.map(1..81, fn _ -> nil end),
            edit_case_color: "blue"

  def click(index, %{positions: pos, edit_case_color: color} = state) do
    new_pos = List.replace_at(pos, String.to_integer(index), color)
    %{state | positions: new_pos}
  end

  def changed_edit_case_color(%{edit_case_color: "blue"} = state),
    do: %{state | edit_case_color: "red"}

  def changed_edit_case_color(%{edit_case_color: "red"} = state),
    do: %{state | edit_case_color: "blue"}
end
