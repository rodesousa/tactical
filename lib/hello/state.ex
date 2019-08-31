defmodule HelloWeb.State do
  defstruct positions: Enum.map(1..81, fn _ -> nil end)
end
